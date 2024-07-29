// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 31/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 41
// *  Descrição Resumida : Cadastro de Pessoas Secundárias - Classe Auxiliar
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    31/07/2002    Criação
// *   Arley     06/08/2002    Adição no cadastro de alguns campos
// ********************************************************************

unit uIntPessoasSecundarias;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntPessoaSecundaria, dbtables, sysutils, db,uFerramentas;

type
  { TIntPessoasSecundarias }
  TIntPessoasSecundarias = class(TIntClasseBDNavegacaoBasica)
  private
    FIntPessoaSecundaria : TIntPessoaSecundaria;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(CodPapelSecundario : Integer; CodOrdenacao: String): Integer;
    function Inserir(NomPessoaSecundaria,
      NomReduzidoPessoaSecundaria, CodNaturezaPessoa, NumCNPJCPF: String;
      CodTipoContato1: Integer; TxtContato1: String;
      CodTipoContato2: Integer; TxtContato2: String;
      CodTipoContato3: Integer; TxtContato3: String;
      CodTipoEndereco: Integer; NomLogradouro, NomBairro, NumCEP,
      NomPais, SglEstado, NomMunicipio, NumMunicipioIBGE, NomDistrito,
      TxtObservacao: String): Integer;
    function Alterar(CodPessoaSecundaria: Integer;
      NomPessoaSecundaria, NomReduzidoPessoaSecundaria,
      CodNaturezaPessoa, NumCNPJCPF: String; CodTipoContato1: Integer;
      TxtContato1: String; CodTipoContato2: Integer;
      TxtContato2: String; CodTipoContato3: Integer;
      TxtContato3: String; CodTipoEndereco: Integer;
      NomLogradouro, NomBairro, NumCEP, NomPais, SglEstado, NomMunicipio,
      NumMunicipioIBGE, NomDistrito, TxtObservacao: String): Integer;
    function Excluir(CodPessoaSecundaria: Integer): Integer;
    function Buscar(CodPessoaSecundaria: Integer): Integer;
    function AdicionarPapelSecundario(CodPessoaSecundaria, CodPapelSecundario: Integer): Integer;
    function RetirarPapelSecundario(CodPessoaSecundaria, CodPapelSecundario: Integer): Integer;
    function PossuiPapelSecundario(CodPessoaSecundaria, CodPapelSecundario: Integer): Integer;
    property IntPessoaSecundaria : TIntPessoaSecundaria read FIntPessoaSecundaria write FIntPessoaSecundaria;
  end;

implementation

{ TIntPessoasSecundarias }
constructor TIntPessoasSecundarias.Create;
begin
  inherited;
  FIntPessoaSecundaria := TIntPessoaSecundaria.Create;
end;

destructor TIntPessoasSecundarias.Destroy;
begin
  FIntPessoaSecundaria.Free;
  inherited;
end;

function TIntPessoasSecundarias.Pesquisar(CodPapelSecundario: Integer; CodOrdenacao: String): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(134) Then Begin
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
  Query.SQL.Add('-- Pessoas secundarias com Papeis informados');
  Query.SQL.Add('select ts.cod_pessoa_produtor              as CodPessoaProdutor');
  Query.SQL.Add('       , ts.cod_pessoa_secundaria          as CodPessoaSecundaria');
  Query.SQL.Add('       , ts.nom_pessoa_secundaria          as NomPessoaSecundaria');
  Query.SQL.Add('       , ts.nom_reduzido_pessoa_secundaria as NomReduzidoPessoaSecundaria');
  Query.SQL.Add('       , ts.cod_tipo_contato_1	            as CodTipoContato1');
  Query.SQL.Add('       , ttt1.sgl_tipo_contato             as SglTipoContato1');
  Query.SQL.Add('       , ts.txt_contato_1		              as TxtContato1');
  Query.SQL.Add('       , ts.cod_tipo_contato_2	            as CodTipoContato2');
  Query.SQL.Add('       , ttt2.sgl_tipo_contato             as SglTipoContato2');
  Query.SQL.Add('       , ts.txt_contato_2		              as TxtContato2');
  Query.SQL.Add('       , ts.cod_tipo_contato_3	            as CodTipoContato3');
  Query.SQL.Add('       , ttt3.sgl_tipo_contato             as SglTipoContato3');
  Query.SQL.Add('       , ts.txt_contato_3		              as TxtContato3');
  Query.SQL.Add('       , ts.cod_tipo_endereco              as CodTipoEndereco');
  Query.SQL.Add('       , ts.nom_logradouro		              as NomLogradouro');
  Query.SQL.Add('       , ts.nom_bairro		                  as NomBairro');
  Query.SQL.Add('       , ts.num_cep			                  as NumCep');
  Query.SQL.Add('       , ts.nom_pais                       as NomPais');
  Query.SQL.Add('       , ts.sgl_estado                     as SglEstado');
  Query.SQL.Add('       , ts.nom_municipio                  as NomMunicipio');
  Query.SQL.Add('       , ts.num_municipio_ibge             as NumMunicipioIBGE');
  Query.SQL.Add('       , ts.nom_distrito                   as NomDistrito');
  Query.SQL.Add('       , ts.txt_observacao	                as TxtObservacao');
  Query.SQL.Add('       , tsp.cod_papel_secundario          as CodPapelSecundario');
  Query.SQL.Add('       , tp.Des_papel_secundario           as DesPapelSecundario');
  Query.SQL.Add('       , ts.num_cnpj_cpf                   as NumCNPJCPF');
  Query.SQL.Add('  from tab_pessoa_secundaria ts ');
  Query.SQL.Add('     , tab_pessoa_papel_secundario tsp ');
  Query.SQL.Add('     , tab_papel_secundario tp ');
  Query.SQL.Add('     , tab_tipo_contato ttt1 ');
  Query.SQL.Add('     , tab_tipo_contato ttt2 ');
  Query.SQL.Add('     , tab_tipo_contato ttt3 ');
  Query.SQL.Add(' where ts.cod_pessoa_produtor    = :cod_pessoa_produtor ');
  Query.SQL.Add('   and tsp.cod_pessoa_produtor   = ts.cod_pessoa_produtor ');
  Query.SQL.Add('   and tsp.cod_pessoa_secundaria = ts.cod_pessoa_secundaria ');
  Query.SQL.Add('   and tp.cod_papel_secundario   = tsp.cod_papel_secundario');
  Query.SQL.Add('   and ttt1.cod_tipo_contato     =* ts.cod_tipo_contato_1');
  Query.SQL.Add('   and ttt2.cod_tipo_contato     =* ts.cod_tipo_contato_2');
  Query.SQL.Add('   and ttt3.cod_tipo_contato     =* ts.cod_tipo_contato_3');
  Query.SQL.Add('   and ts.dta_fim_validade is null ');
  Query.SQL.Add('   and ((tsp.cod_papel_secundario = :cod_papel_secundario) or (:cod_papel_secundario = -1)) ');
  Query.SQL.Add('');
  if CodPapelSecundario < 0 then
  begin
    { Se for selecionada pesquisa por todos os papeis, mostra
      todas as pessoas, mesmo as que não possuem papéis informados! }
    Query.SQL.Add('union');
    Query.SQL.Add('');
    Query.SQL.Add('-- Pessoas secundarias sem Papeis informados');
    Query.SQL.Add('select ts.cod_pessoa_produtor              as CodPessoaProdutor');
    Query.SQL.Add('       , ts.cod_pessoa_secundaria          as CodPessoaSecundaria');
    Query.SQL.Add('       , ts.nom_pessoa_secundaria          as NomPessoaSecundaria');
    Query.SQL.Add('       , ts.nom_reduzido_pessoa_secundaria as NomReduzidoPessoaSecundaria');
    Query.SQL.Add('       , ts.cod_tipo_contato_1             as CodTipoContato1');
    Query.SQL.Add('       , ttt1.sgl_tipo_contato             as SglTipoContato1');
    Query.SQL.Add('       , ts.txt_contato_1                  as TxtContato1');
    Query.SQL.Add('       , ts.cod_tipo_contato_2             as CodTipoContato2');
    Query.SQL.Add('       , ttt2.sgl_tipo_contato             as SglTipoContato2');
    Query.SQL.Add('       , ts.txt_contato_2                  as TxtContato2');
    Query.SQL.Add('       , ts.cod_tipo_contato_3	            as CodTipoContato3');
    Query.SQL.Add('       , ttt3.sgl_tipo_contato             as SglTipoContato3');
    Query.SQL.Add('       , ts.txt_contato_3                  as TxtContato3');
    Query.SQL.Add('       , ts.cod_tipo_endereco              as CodTipoEndereco');
    Query.SQL.Add('       , ts.nom_logradouro	                as NomLogradouro');
    Query.SQL.Add('       , ts.nom_bairro                     as NomBairro');
    Query.SQL.Add('       , ts.num_cep	                      as NumCep');
    Query.SQL.Add('       , ts.nom_pais                       as NomPais');
    Query.SQL.Add('       , ts.sgl_estado                     as SglEstado');
    Query.SQL.Add('       , ts.nom_municipio                  as NomMunicipio');
    Query.SQL.Add('       , ts.num_municipio_ibge             as NumMunicipioIBGE');
    Query.SQL.Add('       , ts.nom_distrito                   as NomDistrito');
    Query.SQL.Add('       , ts.txt_observacao	                as TxtObservacao');
    Query.SQL.Add('       , null         	            	      as CodPapelSecundario');
    Query.SQL.Add('       , null			                        as DesPapelSecundario');
    Query.SQL.Add('       , ts.num_cnpj_cpf	                as NumCNPJCPF');
    Query.SQL.Add('  from tab_pessoa_secundaria ts');
    Query.SQL.Add('     , tab_tipo_contato ttt1 ');
    Query.SQL.Add('     , tab_tipo_contato ttt2 ');
    Query.SQL.Add('     , tab_tipo_contato ttt3 ');
    Query.SQL.Add(' where ts.cod_pessoa_produtor = :cod_pessoa_produtor');
    Query.SQL.Add('     and ts.dta_fim_validade is null');
    Query.SQL.Add('     and ttt1.cod_tipo_contato =* ts.cod_tipo_contato_1');
    Query.SQL.Add('     and ttt2.cod_tipo_contato =* ts.cod_tipo_contato_2');
    Query.SQL.Add('     and ttt3.cod_tipo_contato =* ts.cod_tipo_contato_3');
    Query.SQL.Add('     and not exists (select 1');
    Query.SQL.Add('                     from tab_pessoa_papel_secundario tpps, tab_papel_secundario tps');
    Query.SQL.Add('                     where tpps.cod_papel_secundario = tps.cod_papel_secundario');
    Query.SQL.Add('                       and tpps.cod_pessoa_produtor = ts.cod_pessoa_produtor');
    Query.SQL.Add('                       and tpps.cod_pessoa_secundaria = ts.cod_pessoa_secundaria)');
    Query.SQL.Add('');
  end;
  if Uppercase(CodOrdenacao) = 'N' then begin
    Query.SQL.Add('order by');
    Query.SQL.Add('  NomPessoaSecundaria');
    Query.SQL.Add('  , CodPessoaSecundaria');
    Query.SQL.Add('  , DesPapelSecundario');
  end
  else if Uppercase(CodOrdenacao) = 'R' then Begin
    Query.SQL.Add('order by');
    Query.SQL.Add('  NomReduzidoPessoaSecundaria');
    Query.SQL.Add('  , CodPessoaSecundaria');
    Query.SQL.Add('  , DesPapelSecundario');
  end;
{$ENDIF}

  Query.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
  Query.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(415, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -415;
      Exit;
    End;
  End;
end;

function Se(Condicao: Boolean; Verdadeira, Falsa: String): String;
begin
  if Condicao then
    Result := Verdadeira
  else
    Result := Falsa;
end;

function TIntPessoasSecundarias.Inserir(NomPessoaSecundaria,
  NomReduzidoPessoaSecundaria, CodNaturezaPessoa, NumCNPJCPF: String;
  CodTipoContato1: Integer; TxtContato1: String;
  CodTipoContato2: Integer; TxtContato2: String;
  CodTipoContato3: Integer; TxtContato3: String;
  CodTipoEndereco: Integer; NomLogradouro, NomBairro, NumCEP,
  NomPais, SglEstado, NomMunicipio, NumMunicipioIBGE, NomDistrito,
  TxtObservacao: String): Integer;
var
  Q : THerdomQuery;
  CodPessoaSecundaria, CodRegistroLog : Integer;
  NumCNPJCPFSemDv : String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(136) Then Begin
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

  //---------------------------------
  // Trata Nome da Pessoa Secundaria
  //----------------------------------
  Result := VerificaString(NomPessoaSecundaria, 'Nome da Pessoa Secundária');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomPessoaSecundaria, 50, 'Nome da Pessoa Secundária');
  If Result < 0 Then Begin
    Exit;
  End;

  //------------------------------------------
  // Trata Nome Reduzido da Pessoa Secundaria
  //------------------------------------------
  Result := VerificaString(NomReduzidoPessoaSecundaria, 'Nome Reduzido da Pessoa Secundária');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomReduzidoPessoaSecundaria, 15, 'Nome Reduzido da Pessoa Secundária');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata Natureza
  Result := VerificaString(CodNaturezaPessoa, 'Natureza da Pessoa Secundária');
  If Result < 0 Then Exit;

  Result := TrataString(CodNaturezaPessoa, 1, 'Natureza da Pessoa Secundária');
  If Result < 0 Then Exit;

  if not (CodNaturezaPessoa[1] in ['F', 'J']) then begin
    Mensagens.Adicionar(416, Self.ClassName, 'Inserir', []);
    Result := -416;
    Exit;
  end;

  // Trata número CNPJ ou CPF (se informado)
  if NumCNPJCPF <> '' then begin
    if CodNaturezaPessoa = 'F' then begin
      Result := TrataString(NumCNPJCPF,11, 'Número CPF');
      NumCNPJCPFSemDv := Copy(NumCNPJCPF,1,9);
    end else begin
      Result := TrataString(NumCNPJCPF,14, 'Número CNPJ');
      NumCNPJCPFSemDv := Copy(NumCNPJCPF,1,12);
    end;
    if Result < 0 then Exit;

    if not VerificarCnpjCpf(NumCNPJCPFSemDv,NumCNPJCPF, 'N') then begin
      Mensagens.Adicionar(424, Self.ClassName, 'Inserir', []);
      Result := -424;
      Exit;
    end;
  end;

  //-------------------------------------------------
  // Tratando informações pertinentes a contatos
  //-------------------------------------------------
  // Trata Tipo do contato1 informado e número não
  if CodTipoContato1 > 0 then
  begin
    Result := VerificaString(TxtContato1, 'A descrição do 1º contato');
    if Result < 0 then Exit;
  end;
  // Trata descrição do contato1 informado e tipo não
  if Trim(TxtContato1) <> '' then
  begin
    Result := VerificaString(SE(CodTipoContato1<0, '', 'X'), 'Tipo do 1º contato');
    if Result < 0 then Exit;
    Result := TrataString(TxtContato1, 50, 'Descrição do 1º contato');
    If Result < 0 Then Exit;
  end;
  // Trata Tipo do contato1 informado e número não
  if CodTipoContato2 > 0 then
  begin
    Result := VerificaString(TxtContato2, 'A descrição do 2º contato');
    if Result < 0 then Exit;
  end;
  // Trata descrição do contato2 informado e tipo não
  if Trim(TxtContato2) <> '' then
  begin
    Result := VerificaString(SE(CodTipoContato2<0, '', 'X'), 'Tipo do 2º contato');
    if Result < 0 then Exit;
    Result := TrataString(TxtContato2, 50, 'Descrição do 2º contato');
    If Result < 0 Then Exit;
  end;
  // Trata Tipo do contato1 informado e número não
  if CodTipoContato3 > 0 then
  begin
    Result := VerificaString(TxtContato3, 'A descrição do 3º contato');
    if Result < 0 then Exit;
  end;
  // Trata descrição do contato3 informado e tipo não
  if Trim(TxtContato3) <> '' then
  begin
    Result := VerificaString(SE(CodTipoContato3<0, '', 'X'), 'Tipo do 3º contato');
    if Result < 0 then Exit;
    Result := TrataString(TxtContato3, 50, 'Descrição do 3º contato');
    If Result < 0 Then Exit;
  end;
  if (CodTipoContato3 > 0) and (CodTipoContato2 < 0) then
  begin
    Result := VerificaString('', 'Antes de informar o 3º, o 2º contato');
    if Result < 0 then Exit;
  end;
  if (CodTipoContato2 > 0) and (CodTipoContato1 < 0) then
  begin
    Result := VerificaString('', 'Antes de informar o 2º, o 1º contato');
    if Result < 0 then Exit;
  end;
  if (CodTipoContato3 > 0) and (CodTipoContato1 < 0) then
  begin
    Result := VerificaString('', 'Antes de informar o 3º, o 1º contato');
    if Result < 0 then Exit;
  end;

  //-------------------------------------------------
  // Tratando informações pertinentes a endereço
  //-------------------------------------------------
  // Se o nome do logradouro foi informado o tipo do endereço deve ser
  if (Trim(NomLogradouro) <> '') and (CodTipoEndereco < 0) then
  begin
    Result := VerificaString('', 'O Tipo de Endereço');
    if Result < 0 then Exit;
  end;
  // Se o tipo de endereço foi informado o nome do logradouro deve ser
  if (CodTipoEndereco > 0) and (Trim(NomLogradouro) = '')then
  begin
    Result := VerificaString('', 'O Endereço');
    if Result < 0 then Exit;
  end;
  // Se o nome do logradouro foi informado, o municip. deve ser inf. tb
  if (Trim(NomLogradouro) <> '') and (Trim(NomMunicipio) = '') then
  begin
    Result := VerificaString('', 'O Munícipio');
    if Result < 0 then Exit;
  end;
  // Se o municip. for informado, estado ou país dever ser
  if (Trim(NomMunicipio) <> '') and ((Trim(SglEstado)='') and (Trim(NomPais)='')) then
  begin
    Result := VerificaString('', 'O Estado ou o País');
    if Result < 0 then Exit;
  end;
  // Se o distrito for informado, o municip. deve ser
  if (Trim(NomDistrito) <> '') and (Trim(NomMunicipio)='') then
  begin
    Result := VerificaString('', 'O Município');
    if Result < 0 then Exit;
  end;
  // Se o bairro for informado, o municip. deve ser.
  if (Trim(NomBairro) <> '') and (Trim(NomMunicipio)='') then
  begin
    Result := VerificaString('', 'O Município');
    if Result < 0 then Exit;
  end;

  // Consistindo Tamanho máx. permitido para os campos
  Result := TrataString(NomLogradouro, 100, 'Endereço');
  If Result < 0 Then Exit;
  Result := TrataString(NomBairro, 20, 'Bairro');
  If Result < 0 Then Exit;
  Result := TrataString(NumCEP, 8, 'CEP');
  If Result < 0 Then Exit;
  Result := TrataString(NomPais, 20, 'País');
  If Result < 0 Then Exit;
  Result := TrataString(SglEstado, 2, 'Sigla Estado');
  If Result < 0 Then Exit;
  Result := TrataString(NomMunicipio, 50, 'Município');
  If Result < 0 Then Exit;
  Result := TrataString(NumMunicipioIBGE, 7, 'Nº Município IBGE');
  If Result < 0 Then Exit;
  Result := TrataString(NomDistrito, 50, 'Distrito');
  If Result < 0 Then Exit;
  Result := TrataString(TxtObservacao, 255, 'Observação');
  If Result < 0 Then Exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //--------------------------------------------------
      // Consiste Natureza da Pessoa se estiver preenchida
      //--------------------------------------------------
      if CodNaturezaPessoa <> '' then begin
        Q.SQL.Clear;
      {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_natureza_pessoa ');
        Q.SQL.Add(' where cod_natureza_pessoa = :cod_natureza_pessoa ');
      {$ENDIF}
        Q.ParamByName('cod_natureza_pessoa').AsString := CodNaturezaPessoa;
        Q.Open;
        If Q.IsEmpty Then Begin
          Mensagens.Adicionar(416, Self.ClassName, 'Inserir', []);
          Result := -416;
          Exit;
        End;
        Q.Close;
      end;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_pessoa_secundaria), 0) + 1 as cod_pessoa_secundaria ');
      Q.SQL.Add('  from tab_pessoa_secundaria ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.Open;

      CodPessoaSecundaria := Q.FieldByName('cod_pessoa_Secundaria').AsInteger;

      // Pega próximo CodRegistroLog
      CodRegistroLog := ProximoCodRegistroLog;
      If CodRegistroLog < 0 Then Begin
        Rollback;
        Result := CodRegistroLog;
        Exit;
      End;
      //------------------------
      // Tenta Inserir Registro
      //------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_pessoa_secundaria ');
      Q.SQL.Add(' ( cod_pessoa_produtor ');
      Q.SQL.Add(' , cod_pessoa_secundaria ');
      Q.SQL.Add(' , nom_pessoa_secundaria ');
      Q.SQL.Add(' , nom_reduzido_pessoa_secundaria ');
      Q.SQL.Add(' , cod_natureza_pessoa ');
      Q.SQL.Add(' , num_cnpj_cpf ');
      Q.SQL.Add(' , cod_tipo_contato_1');
      Q.SQL.Add(' , txt_contato_1');
      Q.SQL.Add(' , cod_tipo_contato_2');
      Q.SQL.Add(' , txt_contato_2');
      Q.SQL.Add(' , cod_tipo_contato_3');
      Q.SQL.Add(' , txt_contato_3');
      Q.SQL.Add(' , cod_tipo_endereco');
      Q.SQL.Add(' , nom_logradouro');
      Q.SQL.Add(' , nom_bairro');
      Q.SQL.Add(' , num_cep');
      Q.SQL.Add(' , nom_pais');
      Q.SQL.Add(' , sgl_estado');
      Q.SQL.Add(' , nom_municipio');
      Q.SQL.Add(' , num_municipio_ibge');
      Q.SQL.Add(' , nom_distrito');
      Q.SQL.Add(' , txt_observacao ');
      Q.SQL.Add(' , dta_cadastramento');
      Q.SQL.Add(' , cod_registro_log ');
      Q.SQL.Add(' , dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' ( :cod_pessoa_produtor ');
      Q.SQL.Add(' , :cod_pessoa_secundaria ');
      Q.SQL.Add(' , :nom_pessoa_secundaria ');
      Q.SQL.Add(' , :nom_reduzido_pessoa_secundaria ');
      Q.SQL.Add(' , :cod_natureza_pessoa ');
      Q.SQL.Add(' , :num_cnpj_cpf ');
      Q.SQL.Add(' , :cod_tipo_contato_1');
      Q.SQL.Add(' , :txt_contato_1');
      Q.SQL.Add(' , :cod_tipo_contato_2');
      Q.SQL.Add(' , :txt_contato_2');
      Q.SQL.Add(' , :cod_tipo_contato_3');
      Q.SQL.Add(' , :txt_contato_3');
      Q.SQL.Add(' , :cod_tipo_endereco');
      Q.SQL.Add(' , :nom_logradouro');
      Q.SQL.Add(' , :nom_bairro');
      Q.SQL.Add(' , :num_cep');
      Q.SQL.Add(' , :nom_pais');
      Q.SQL.Add(' , :sgl_estado');
      Q.SQL.Add(' , :nom_municipio');
      Q.SQL.Add(' , :num_municipio_ibge');
      Q.SQL.Add(' , :nom_distrito');
      Q.SQL.Add(' , :txt_observacao ');
      Q.SQL.Add(' , getdate()');
      Q.SQL.Add(' , :cod_registro_log ');
      Q.SQL.Add(' , null) ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger           := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_pessoa_secundaria').AsInteger         := CodPessoaSecundaria;
      Q.ParamByName('nom_pessoa_secundaria').AsString          := NomPessoaSecundaria;
      Q.ParamByName('nom_reduzido_pessoa_secundaria').AsString := NomReduzidoPessoaSecundaria;
      if trim(CodNaturezaPessoa) = '' then begin
        Q.ParamByName('cod_natureza_pessoa').DataType := ftString;
        Q.ParamByName('num_cnpj_cpf').DataType := ftString;
        Q.ParamByName('cod_natureza_pessoa').Clear;
        Q.ParamByName('num_cnpj_cpf').clear;
      end
      else begin
        Q.ParamByName('cod_natureza_pessoa').AsString            := CodNaturezaPessoa;
        Q.ParamByName('num_cnpj_cpf').AsString                   := NumCnpjCpf;
      end;

      // Definindo tipo dos dados
      Q.ParamByName('cod_tipo_contato_1').DataType  :=ftInteger;
      Q.ParamByName('txt_contato_1').DataType       :=ftString;
      Q.ParamByName('cod_tipo_contato_2').DataType  :=ftInteger;
      Q.ParamByName('txt_contato_2').DataType       :=ftString;
      Q.ParamByName('cod_tipo_contato_3').DataType  :=ftInteger;
      Q.ParamByName('txt_contato_3').DataType       :=ftString;
      Q.ParamByName('cod_tipo_endereco').DataType   :=ftInteger;
      Q.ParamByName('nom_logradouro').DataType      :=ftString;
      Q.ParamByName('nom_bairro').DataType          :=ftString;
      Q.ParamByName('num_cep').DataType             :=ftString;
      Q.ParamByName('nom_pais').DataType            :=ftString;
      Q.ParamByName('sgl_estado').DataType          :=ftString;
      Q.ParamByName('nom_municipio').DataType       :=ftString;
      Q.ParamByName('num_municipio_ibge').DataType  :=ftString;
      Q.ParamByName('nom_distrito').DataType        :=ftString;

      // Atribuindo os valores dos campos
      AtribuiValorParametro(Q.ParamByName('cod_tipo_contato_1'), CodTipoContato1);
      AtribuiValorParametro(Q.ParamByName('txt_contato_1'), TxtContato1);
      AtribuiValorParametro(Q.ParamByName('cod_tipo_contato_2'), CodTipoContato2);
      AtribuiValorParametro(Q.ParamByName('txt_contato_2'), TxtContato2);
      AtribuiValorParametro(Q.ParamByName('cod_tipo_contato_3'), CodTipoContato3);
      AtribuiValorParametro(Q.ParamByName('txt_contato_3'), TxtContato3);
      AtribuiValorParametro(Q.ParamByName('cod_tipo_endereco'), CodTipoEndereco);
      AtribuiValorParametro(Q.ParamByName('nom_logradouro'), NomLogradouro);
      AtribuiValorParametro(Q.ParamByName('nom_bairro'), NomBairro);
      AtribuiValorParametro(Q.ParamByName('num_cep'), NumCep);
      AtribuiValorParametro(Q.ParamByName('nom_pais'), NomPais);
      AtribuiValorParametro(Q.ParamByName('sgl_estado'), SglEstado);
      AtribuiValorParametro(Q.ParamByName('nom_municipio'), NomMunicipio);
      AtribuiValorParametro(Q.ParamByName('num_municipio_ibge'), NumMunicipioIBGE);
      AtribuiValorParametro(Q.ParamByName('nom_distrito'), NomDistrito);

      if trim(txtObservacao)='' then begin
         Q.ParamByName('txt_observacao').DataType := ftString;
         Q.ParamByName('txt_observacao').clear;
      end
      else begin
         Q.ParamByName('txt_observacao').AsString                 := txtObservacao;
      end;
      Q.ParamByName('cod_registro_log').AsInteger              := CodRegistroLog;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa_secundaria', CodRegistroLog, 1, 92);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodPessoaSecundaria;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(417, Self.ClassName, 'Inserir', [E.Message]);
        Result := -417;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPessoasSecundarias.Alterar(CodPessoaSecundaria: Integer;
  NomPessoaSecundaria, NomReduzidoPessoaSecundaria,
  CodNaturezaPessoa, NumCNPJCPF: String; CodTipoContato1: Integer;
  TxtContato1: String; CodTipoContato2: Integer;
  TxtContato2: String; CodTipoContato3: Integer;
  TxtContato3: String; CodTipoEndereco: Integer;
  NomLogradouro, NomBairro, NumCEP, NomPais, SglEstado, NomMunicipio,
  NumMunicipioIBGE, NomDistrito, TxtObservacao: String): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
  NumCNPJCPFSemDv: String;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(137) Then Begin
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

  //----------------------------------
  // Trata Nome da Pessoa Secundaria
  //----------------------------------
  Result := VerificaString(NomPessoaSecundaria, 'Nome da Pessoa Secundária');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomPessoaSecundaria, 50, 'Nome da Pessoa Secundária');
  If Result < 0 Then Begin
    Exit;
  End;

  //------------------------------------------
  // Trata Nome Reduzido da Pessoa Secundaria
  //------------------------------------------
  Result := VerificaString(NomReduzidoPessoaSecundaria, 'Nome Reduzido da Pessoa Secundária');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(NomReduzidoPessoaSecundaria, 15, 'Nome Reduzido da Pessoa Secundária');
  If Result < 0 Then Begin
    Exit;
  End;

  //-------------------------------------------------
  // Tratando informações pertinentes a contatos
  //-------------------------------------------------
  // Trata Tipo do contato1 informado e número não
  if CodTipoContato1 > 0 then
  begin
    Result := VerificaString(TxtContato1, 'A descrição do 1º contato');
    if Result < 0 then Exit;
  end;
  // Trata descrição do contato1 informado e tipo não
  if Trim(TxtContato1) <> '' then
  begin
    Result := VerificaString(SE(CodTipoContato1<0, '', 'X'), 'Tipo do 1º contato');
    if Result < 0 then Exit;
    Result := TrataString(TxtContato1, 50, 'Descrição do 1º contato');
    If Result < 0 Then Exit;
  end;
  // Trata Tipo do contato1 informado e número não
  if CodTipoContato2 > 0 then
  begin
    Result := VerificaString(TxtContato2, 'A descrição do 2º contato');
    if Result < 0 then Exit;
  end;
  // Trata descrição do contato2 informado e tipo não
  if Trim(TxtContato2) <> '' then
  begin
    Result := VerificaString(SE(CodTipoContato2<0, '', 'X'), 'Tipo do 2º contato');
    if Result < 0 then Exit;
    Result := TrataString(TxtContato2, 50, 'Descrição do 2º contato');
    If Result < 0 Then Exit;
  end;
  // Trata Tipo do contato1 informado e número não
  if CodTipoContato3 > 0 then
  begin
    Result := VerificaString(TxtContato3, 'A descrição do 3º contato');
    if Result < 0 then Exit;
  end;
  // Trata descrição do contato3 informado e tipo não
  if Trim(TxtContato3) <> '' then
  begin
    Result := VerificaString(SE(CodTipoContato3<0, '', 'X'), 'Tipo do 3º contato');
    if Result < 0 then Exit;
    Result := TrataString(TxtContato3, 50, 'Descrição do 3º contato');
    If Result < 0 Then Exit;
  end;
  if (CodTipoContato3 > 0) and (CodTipoContato2 < 0) then
  begin
    Result := VerificaString('', 'Antes de informar o 3º, o 2º contato');
    if Result < 0 then Exit;
  end;
  if (CodTipoContato2 > 0) and (CodTipoContato1 < 0) then
  begin
    Result := VerificaString('', 'Antes de informar o 2º, o 1º contato');
    if Result < 0 then Exit;
  end;
  if (CodTipoContato3 > 0) and (CodTipoContato1 < 0) then
  begin
    Result := VerificaString('', 'Antes de informar o 3º, o 1º contato');
    if Result < 0 then Exit;
  end;

  //-------------------------------------------------
  // Tratando informações pertinentes a endereço
  //-------------------------------------------------
  // Se o nome do logradouro foi informado o tipo do endereço deve ser
  if (Trim(NomLogradouro) <> '') and (CodTipoEndereco < 0) then
  begin
    Result := VerificaString('', 'O Tipo de Endereço');
    if Result < 0 then Exit;
  end;
  // Se o tipo de endereço foi informado o nome do logradouro deve ser
  if (CodTipoEndereco > 0) and (Trim(NomLogradouro) = '')then
  begin
    Result := VerificaString('', 'O Endereço');
    if Result < 0 then Exit;
  end;
  // Se o nome do logradouro foi informado, o municip. deve ser inf. tb
  if (Trim(NomLogradouro) <> '') and (Trim(NomMunicipio) = '') then
  begin
    Result := VerificaString('', 'O Munícipio');
    if Result < 0 then Exit;
  end;
  // Se o municip. for informado, estado ou país dever ser
  if (Trim(NomMunicipio) <> '') and ((Trim(SglEstado)='') and (Trim(NomPais)='')) then
  begin
    Result := VerificaString('', 'O Estado ou o País');
    if Result < 0 then Exit;
  end;
  // Se o distrito for informado, o municip. deve ser
  if (Trim(NomDistrito) <> '') and (Trim(NomMunicipio)='') then
  begin
    Result := VerificaString('', 'O Município');
    if Result < 0 then Exit;
  end;
  // Se o bairro for informado, o municip. deve ser.
  if (Trim(NomBairro) <> '') and (Trim(NomMunicipio)='') then
  begin
    Result := VerificaString('', 'O Município');
    if Result < 0 then Exit;
  end;

  // Consistindo Tamanho máx. permitido para os campos
  Result := TrataString(NomLogradouro, 100, 'Endereço');
  If Result < 0 Then Exit;
  Result := TrataString(NomBairro, 20, 'Bairro');
  If Result < 0 Then Exit;
  Result := TrataString(NumCEP, 8, 'CEP');
  If Result < 0 Then Exit;
  Result := TrataString(NomPais, 20, 'País');
  If Result < 0 Then Exit;
  Result := TrataString(SglEstado, 2, 'Sigla Estado');
  If Result < 0 Then Exit;
  Result := TrataString(NomMunicipio, 50, 'Município');
  If Result < 0 Then Exit;
  Result := TrataString(NumMunicipioIBGE, 7, 'Nº Município IBGE');
  If Result < 0 Then Exit;
  Result := TrataString(NomDistrito, 50, 'Distrito');
  If Result < 0 Then Exit;
  Result := TrataString(TxtObservacao, 255, 'Observação');
  If Result < 0 Then Exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      //---------------------------------
      // Verifica existência do registro
      //---------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_natureza_pessoa, num_cnpj_cpf, cod_registro_log ');
      Q.SQL.Add('  from tab_pessoa_secundaria ');
      Q.SQL.Add(' where cod_pessoa_produtor   = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(418, Self.ClassName, 'Alterar', []);
        Result := -418;
        Exit;
      End;
      // Consiste se a natureza não foi alterada
      If Q.FieldByName('cod_natureza_pessoa').AsString <> CodNaturezaPessoa Then Begin
        Mensagens.Adicionar(757, Self.ClassName, 'Alterar', []);
        Result := -757;
        Exit;
      End;
      // Consiste se o número do CNPJ/CPF não foi alterado (caso ele já tenha sido informado)
      If (Q.FieldByName('num_cnpj_cpf').AsString <> '') and (Q.FieldByName('num_cnpj_cpf').AsString <> NumCNPJCPF) Then Begin
        Mensagens.Adicionar(758, Self.ClassName, 'Alterar', []);
        Result := -758;
        Exit;
      End;
      CodNaturezaPessoa := Q.FieldByName('cod_natureza_pessoa').AsString;
      if NumCNPJCPF <> '' then Begin
        // Trata número CNPJ ou CPF
        if CodNaturezaPessoa = 'F' then begin
          Result := TrataString(NumCNPJCPF,11, 'Número CPF');
          NumCNPJCPFSemDv := Copy(NumCNPJCPF,1,9);
        end else begin
          Result := TrataString(NumCNPJCPF,14, 'Número CNPJ');
          NumCNPJCPFSemDv := Copy(NumCNPJCPF,1,12);
        end;
        if Result < 0 then Exit;
        if not VerificarCnpjCpf(NumCNPJCPFSemDv, NumCNPJCPF, 'N') then begin
          Mensagens.Adicionar(424, Self.ClassName, 'Alterar', []);
          Result := -424;
          Exit;
        end;
      end;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa_secundaria', CodRegistroLog, 2, 93);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_pessoa_secundaria ');
      Q.SQL.Add('   set  nom_pessoa_secundaria = :Nom_Pessoa_Secundaria, ');
      Q.SQL.Add('   nom_reduzido_pessoa_secundaria = :nom_reduzido_pessoa_secundaria, ');
//      Q.SQL.Add('   cod_natureza_pessoa = :cod_natureza_pessoa,'); // não pode ser alterada!
      Q.SQL.Add('   num_cnpj_cpf = :num_cnpj_cpf,');
      Q.SQL.Add('   cod_tipo_contato_1 = :cod_tipo_contato_1,');
      Q.SQL.Add('   txt_contato_1 = :txt_contato_1,');
      Q.SQL.Add('   cod_tipo_contato_2 = :cod_tipo_contato_2,');
      Q.SQL.Add('   txt_contato_2 = :txt_contato_2,');
      Q.SQL.Add('   cod_tipo_contato_3 = :cod_tipo_contato_3,');
      Q.SQL.Add('   txt_contato_3 = :txt_contato_3,');
      Q.SQL.Add('   cod_tipo_endereco = :cod_tipo_endereco,');
      Q.SQL.Add('   nom_logradouro = :nom_logradouro,');
      Q.SQL.Add('   nom_bairro = :nom_bairro,');
      Q.SQL.Add('   num_cep = :num_cep,');
      Q.SQL.Add('   nom_pais = :nom_pais,');
      Q.SQL.Add('   sgl_estado = :sgl_estado,');
      Q.SQL.Add('   nom_municipio = :nom_municipio,');
      Q.SQL.Add('   num_municipio_ibge = :num_municipio_ibge,');
      Q.SQL.Add('   nom_distrito = :nom_distrito,');

      Q.SQL.Add('   txt_observacao = :txt_observacao,');
      // Pra tirar a merda de vírgula que fica na última linha antes do where
      Q.SQL[Q.SQL.Count-1] := Copy(Q.SQL[Q.SQL.Count-1], 1, Length(Q.SQL[Q.SQL.Count-1]) - 1);

      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
      Q.ParamByName('Nom_pessoa_secundaria').AsString := NomPessoaSecundaria;
      Q.ParamByName('Nom_reduzido_pessoa_secundaria').AsString := NomReduzidoPessoaSecundaria;

//      Q.ParamByName('cod_natureza_pessoa').AsString            := CodNaturezaPessoa; // Não pode ser alterada!

      // Definindo tipo dos dados
      Q.ParamByName('num_cnpj_cpf').DataType       :=ftString;
      Q.ParamByName('cod_tipo_contato_1').DataType :=ftInteger;
      Q.ParamByName('txt_contato_1').DataType      :=ftString;
      Q.ParamByName('cod_tipo_contato_2').DataType :=ftInteger;
      Q.ParamByName('txt_contato_2').DataType      :=ftString;
      Q.ParamByName('cod_tipo_contato_3').DataType :=ftInteger;
      Q.ParamByName('txt_contato_3').DataType      :=ftString;
      Q.ParamByName('cod_tipo_endereco').DataType  :=ftInteger;
      Q.ParamByName('nom_logradouro').DataType     :=ftString;
      Q.ParamByName('nom_bairro').DataType         :=ftString;
      Q.ParamByName('num_cep').DataType            :=ftString;
      Q.ParamByName('nom_pais').DataType           :=ftString;
      Q.ParamByName('sgl_estado').DataType         :=ftString;
      Q.ParamByName('nom_municipio').DataType      :=ftString;
      Q.ParamByName('num_municipio_ibge').DataType :=ftString;
      Q.ParamByName('nom_distrito').DataType       :=ftString;

      // Atribuindo os valores dos campos
      AtribuiValorParametro(Q.ParamByName('num_cnpj_cpf'), NumCnpjCpf);
      AtribuiValorParametro(Q.ParamByName('cod_tipo_contato_1'), CodTipoContato1);
      AtribuiValorParametro(Q.ParamByName('txt_contato_1'), TxtContato1);
      AtribuiValorParametro(Q.ParamByName('cod_tipo_contato_2'), CodTipoContato2);
      AtribuiValorParametro(Q.ParamByName('txt_contato_2'), TxtContato2);
      AtribuiValorParametro(Q.ParamByName('cod_tipo_contato_3'), CodTipoContato3);
      AtribuiValorParametro(Q.ParamByName('txt_contato_3'), TxtContato3);
      AtribuiValorParametro(Q.ParamByName('cod_tipo_endereco'), CodTipoEndereco);
      AtribuiValorParametro(Q.ParamByName('nom_logradouro'), NomLogradouro);
      AtribuiValorParametro(Q.ParamByName('nom_bairro'), NomBairro);
      AtribuiValorParametro(Q.ParamByName('num_cep'), NumCep);
      AtribuiValorParametro(Q.ParamByName('nom_pais'), NomPais);
      AtribuiValorParametro(Q.ParamByName('sgl_estado'), SglEstado);
      AtribuiValorParametro(Q.ParamByName('nom_municipio'), NomMunicipio);
      AtribuiValorParametro(Q.ParamByName('num_municipio_ibge'), NumMunicipioIBGE);
      AtribuiValorParametro(Q.ParamByName('nom_distrito'), NomDistrito);

      if trim(txtObservacao)='' then begin
         Q.ParamByName('txt_observacao').DataType                 := ftString;
         Q.ParamByName('txt_observacao').clear;
      end
      else begin
         Q.ParamByName('txt_observacao').AsString                 := txtObservacao;
      end;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa_secundaria', CodRegistroLog, 3, 93);
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
        Mensagens.Adicionar(419, Self.ClassName, 'Alterar', [E.Message]);
        Result := -419;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPessoasSecundarias.Excluir(CodPessoaSecundaria: Integer): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(138) Then Begin
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

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      //---------------------------------
      // Verifica existência do registro
      //---------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_registro_log from tab_pessoa_secundaria ');
      Q.SQL.Add(' where cod_pessoa_produtor   = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(418, Self.ClassName, 'Alterar', []);
        Result := -418;
        Exit;
      End;
      CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      Q.Close;

      // Verifica se a pessoa é o frigorífico ou aglomeração de algum animal
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_animal ' +
                ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
                '   and cod_pessoa_secundaria_corrente = :cod_pessoa ' +
                '   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoaSecundaria;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(755, Self.ClassName, 'Excluir', []);
        Result := -755;
        Exit;
      end;
      Q.Close;

      // Verifica se a pessoa em questão é a pessoa sec. de origem ou de destino
      // de um evento de transferência
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_evento_transferencia ' +
                ' where cod_pessoa_secundaria_destino = :cod_pessoa ' +
                '    or cod_pessoa_secundaria_origem = :cod_pessoa '+
                '    and cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoaSecundaria;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(914, Self.ClassName, 'Excluir', []);
        Result := -914;
        Exit;
      end;
      Q.Close;

      // Verifica se a pessoa em questão é criador de algum evento
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select * from tab_evento_venda_criador '+
                ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
                '   and cod_pessoa_secundaria = :cod_pessoa ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_pessoa').AsInteger := CodPessoaSecundaria;
      Q.Open;
      if not Q.IsEmpty then begin
        Mensagens.Adicionar(1024, Self.ClassName, 'Excluir', []);
        Result := -1024;
        Exit;
      end;
      Q.Close;

      // Abre transação
      BeginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_pessoa_secundaria', CodRegistroLog, 5, 95);
      If Result < 0 Then Begin
        Rollback;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_pessoa_secundaria ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(420, Self.ClassName, 'Excluir', [E.Message]);
        Result := -420;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPessoasSecundarias.Buscar(CodPessoaSecundaria: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(135) Then Begin
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
      //----------------
      // Busca Registro
      //----------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select '+
                '  tps.cod_pessoa_produtor '+
                '  , tps.cod_pessoa_secundaria '+
                '  , tps.nom_pessoa_secundaria '+
                '  , tps.nom_reduzido_pessoa_secundaria '+
                '  , tps.cod_natureza_pessoa '+
                '  , tps.num_cnpj_cpf '+
                '  , case tps.cod_natureza_pessoa '+
                '     when ''F'' then convert(varchar(18), '+
                '                         substring(tps.num_cnpj_cpf, 1, 3) + ''.'' + '+
                '                         substring(tps.num_cnpj_cpf, 4, 3) + ''.'' + '+
                '                         substring(tps.num_cnpj_cpf, 7, 3) + ''-'' + '+
                '                         substring(tps.num_cnpj_cpf, 10, 2)) '+
                '     when ''J'' then convert(varchar(18), '+
                '                         substring(tps.num_cnpj_cpf, 1, 2) + ''.'' + '+
                '                         substring(tps.num_cnpj_cpf, 3, 3) + ''.'' + '+
                '                         substring(tps.num_cnpj_cpf, 6, 3) + ''/'' + '+
                '                         substring(tps.num_cnpj_cpf, 9, 4) + ''-'' + '+
                '                         substring(tps.num_cnpj_cpf, 13, 2)) '+
                '   end as num_cnpj_cpf_formatado '+
                '  , tps.cod_tipo_contato_1 '+
                '  , ttc1.des_tipo_contato as des_tipo_contato_1 '+
                '  , tps.txt_contato_1 '+
                '  , tps.cod_tipo_contato_2 '+
                '  , ttc2.des_tipo_contato as des_tipo_contato_2 '+
                '  , tps.txt_contato_2 '+
                '  , tps.cod_tipo_contato_3 '+
                '  , ttc3.des_tipo_contato as des_tipo_contato_3 '+
                '  , tps.txt_contato_3 '+
                '  , tps.cod_tipo_endereco '+
                '  , tps.nom_logradouro '+
                '  , tps.nom_bairro '+
                '  , tps.num_cep '+
                '  , tps.nom_pais '+
                '  , tps.sgl_estado '+
                '  , tps.nom_municipio '+
                '  , tps.num_municipio_ibge '+
                '  , tps.nom_distrito '+
                '  , tps.txt_observacao '+
                '  , tps.dta_cadastramento '+
                'from '+
                '  tab_pessoa_secundaria tps '+
                '  , tab_tipo_contato ttc1 '+
                '  , tab_tipo_contato ttc2 '+
                '  , tab_tipo_contato ttc3 '+
                'where '+
                '  ttc1.cod_tipo_contato =* tps.cod_tipo_contato_1 '+
                '  and ttc2.cod_tipo_contato =* tps.cod_tipo_contato_2 '+
                '  and ttc3.cod_tipo_contato =* tps.cod_tipo_contato_3 '+
                '  and tps.cod_pessoa_produtor = :cod_pessoa_produtor '+
                '  and tps.cod_pessoa_secundaria = :cod_pessoa_secundaria '+
                '  and tps.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(418, Self.ClassName, 'Buscar', []);
        Result := -418;
        Exit;
      End;

      // Obtem informações do registro
      IntPessoaSecundaria.CodPessoaProdutor             := Q.FieldByName('cod_pessoa_produtor').AsInteger;
      IntPessoaSecundaria.CodPessoaSecundaria           := Q.FieldByName('cod_pessoa_Secundaria').AsInteger;
      IntPessoaSecundaria.NomPessoaSecundaria           := Q.FieldByName('nom_pessoa_Secundaria').AsString;
      IntPessoaSecundaria.NomReduzidoPessoaSecundaria   := Q.FieldByName('nom_Reduzido_pessoa_Secundaria').AsString;
      IntPessoaSecundaria.CodNaturezaPessoa             := Q.FieldByName('cod_natureza_pessoa').AsString;
      IntPessoaSecundaria.NumCNPJCPF                    := Q.FieldByName('num_cnpj_cpf').AsString;
      if Q.FieldByName('num_cnpj_cpf').AsString = '' then
        IntPessoaSecundaria.NumCNPJCPFFormatado           := ''
      else
        IntPessoaSecundaria.NumCNPJCPFFormatado           := Q.FieldByName('num_cnpj_cpf_formatado').AsString;
      IntPessoaSecundaria.CodTipoContato1               := Q.FieldByName('cod_tipo_contato_1').AsInteger;
      IntPessoaSecundaria.DesTipoContato1               := Q.FieldByName('des_tipo_contato_1').AsString;
      IntPessoaSecundaria.TxtContato1                   := Q.FieldByName('txt_contato_1').AsString;
      IntPessoaSecundaria.CodTipoContato2               := Q.FieldByName('cod_tipo_contato_2').AsInteger;
      IntPessoaSecundaria.DesTipoContato2               := Q.FieldByName('des_tipo_contato_2').AsString;
      IntPessoaSecundaria.TxtContato2                   := Q.FieldByName('txt_contato_2').AsString;
      IntPessoaSecundaria.CodTipoContato3               := Q.FieldByName('cod_tipo_contato_3').AsInteger;
      IntPessoaSecundaria.DesTipoContato3               := Q.FieldByName('des_tipo_contato_3').AsString;
      IntPessoaSecundaria.TxtContato3                   := Q.FieldByName('txt_contato_3').AsString;
      IntPessoaSecundaria.CodTipoEndereco               := Q.FieldByName('cod_tipo_endereco').AsInteger;
      IntPessoaSecundaria.NomLogradouro                 := Q.FieldByName('nom_logradouro').AsString;
      IntPessoaSecundaria.NomBairro                     := Q.FieldByName('nom_bairro').AsString;
      IntPessoaSecundaria.NumCep                        := Q.FieldByName('num_cep').AsString;
      IntPessoaSecundaria.NomPais                       := Q.FieldByName('nom_pais').AsString;
      IntPessoaSecundaria.SglEstado                     := Q.FieldByName('sgl_estado').AsString;
      IntPessoaSecundaria.NomMunicipio                  := Q.FieldByName('nom_municipio').AsString;
      IntPessoaSecundaria.NumMunicipioIBGE              := Q.FieldByName('num_municipio_ibge').AsString;
      IntPessoaSecundaria.NomDistrito                   := Q.FieldByName('nom_distrito').AsString;
      IntPessoaSecundaria.TxtObservacao                 := Q.FieldByName('txt_observacao').AsString;
      IntPessoaSecundaria.DtaCadastramento              := Q.FieldByName('dta_cadastramento').AsDateTime;
      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(421, Self.ClassName, 'Buscar', [E.Message]);
        Result := -421;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPessoasSecundarias.AdicionarPapelSecundario(CodPessoaSecundaria, CodPapelSecundario: Integer): Integer;
var
  Q: THerdomQuery;
  sCodNatureza, sNumCNPJCPF, sDesPapelSecundario: String;
  NumMaxPes: Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('AdicionarPapelSecundario');
    Exit;
  End;
  //-----------------------------------------
  // Verifica se usuário pode executar método
  //-----------------------------------------
  If Not Conexao.PodeExecutarMetodo(139) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'AdicionarPapelSecundario', []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'AdicionarPapelSecundario', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

     //----------------------------
     // Consiste Pessoa Secundária
     //----------------------------
       Q.SQL.Clear;
{$IFDEF MSSQL}
       Q.SQL.Add('select cod_natureza_pessoa, num_cnpj_cpf from tab_pessoa_secundaria ');
       Q.SQL.Add(' where cod_pessoa_produtor   = :cod_pessoa_produtor ');
       Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria ');
       Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
       Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
       Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
       Q.Open;
       If Q.IsEmpty Then Begin
         Mensagens.Adicionar(418, Self.ClassName, 'AdicionarPapelSecundario', []);
         Result := -418;
         Exit;
       End;
       sCodNatureza := Q.FieldByName('cod_natureza_pessoa').AsString;
       sNumCNPJCPF := Q.FieldByName('num_cnpj_cpf').AsString;
       Q.Close;

       //--------------------------
       // Consiste Papel Secundário
       //--------------------------
       Q.SQL.Clear;
{$IFDEF MSSQL}
       Q.SQL.Add('select cod_natureza_pessoa, ind_cnpj_cpf_obrigatorio, des_papel_secundario from tab_papel_secundario ');
       Q.SQL.Add(' where cod_papel_secundario = :cod_papel_secundario ');
       Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
       Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
       Q.Open;
       If Q.IsEmpty Then Begin
         Mensagens.Adicionar(422, Self.ClassName, 'AdicionarPapelSecundario', []);
         Result := -422;
         Exit;
       End;
       // Consiste se o papel informado se aplica a natureza da pessoa
       If (Q.FieldByName('cod_natureza_pessoa').AsString <> 'A') and (Q.FieldByName('cod_natureza_pessoa').AsString <> sCodNatureza) then begin
         Mensagens.Adicionar(756, Self.ClassName, 'AdicionarPapelSecundario', []);
         Result := -756;
         Exit;
       End;
       // Consiste se o papel obriga a informação do número cnpj_cpf
       If (Q.FieldByName('ind_cnpj_cpf_obrigatorio').AsString = 'S') and (sNumCNPJCPF = '') Then Begin
         Mensagens.Adicionar(759, Self.ClassName, 'AdicionarPapelSecundario', []);
         Result := -759;
         Exit;
       End;
       sDesPapelSecundario := Q.FieldByName('des_papel_secundario').AsString;
       Q.Close;

      //--------------------------------------------------------
      // Obtem Nº máximo do Parâmentro pessoas secundárias de um
      //  papel por produtor
      //--------------------------------------------------------
      NumMaxPes := StrToInt(ValorParametro(5));

     //---------------------------------------------------------
     // Obtem Quantidade real existempessoas secundárias de um
     //  papel por produtor
     //---------------------------------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select count(*) as QtdReal from tab_pessoa_secundaria tps ');
      Q.SQL.Add('     , tab_pessoa_papel_secundario tpps ');
      Q.SQL.Add(' where tps.cod_pessoa_produtor   = :cod_pessoa_produtor ');
      Q.SQL.Add('   and tpps.cod_pessoa_secundaria  =  tps.cod_pessoa_secundaria ');
      Q.SQL.Add('   and tpps.cod_papel_secundario   =  :cod_papel_secundario ');
      Q.SQL.Add('   and tps.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
      Q.Open;

      If NumMaxPes <= Q.FieldByName('QtdReal').asInteger  Then Begin
        Mensagens.Adicionar(426, Self.ClassName, 'AdicionarPapelSecundario', [sDesPapelSecundario]);
        Result := -426;
        Exit;
      End;
      Q.Close;

      //----------------------------------
      // Verifica existencia do registro
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa_papel_secundario ');
      Q.SQL.Add(' where cod_pessoa_produtor   = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_papel_secundario  = :cod_papel_secundario ');
      Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
      Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
      Q.Open;

      If Q.IsEmpty Then Begin
        Q.Close;

        //----------------
        // Abre transação
        //----------------
        BeginTran;

        //------------------------
        // Tenta Inserir Registro
        //-----------------------
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_pessoa_papel_secundario ');
        Q.SQL.Add(' (cod_pessoa_produtor  , ');
        Q.SQL.Add('  cod_pessoa_secundaria, ');
        Q.SQL.Add('  cod_papel_secundario) ');
        Q.SQL.Add('values ');
        Q.SQL.Add(' (:cod_pessoa_produtor , ');
        Q.SQL.Add('  :cod_pessoa_secundaria, ');
        Q.SQL.Add('  :cod_papel_secundario) ');
  {$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
        Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
        Q.ExecSQL;

        commit;
      end;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(423, Self.ClassName, 'AdicionarPapelSecundario', [E.Message]);
        Result := -423;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPessoasSecundarias.RetirarPapelSecundario(CodPessoaSecundaria, CodPapelSecundario: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('RetirarPapelSecundario');
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(140) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'RetirarPapelSecundario', []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'RetirarPapelSecundario', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

     //----------------------------
     // Consiste Pessoa Secundária
     //----------------------------
       Q.SQL.Clear;
    {$IFDEF MSSQL}
       Q.SQL.Add('select 1 from tab_pessoa_secundaria ');
       Q.SQL.Add(' where cod_pessoa_produtor   = :cod_pessoa_produtor ');
       Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria ');
       Q.SQL.Add('   and dta_fim_validade is null ');
    {$ENDIF}
       Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
       Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
       Q.Open;
       If Q.IsEmpty Then Begin
         Mensagens.Adicionar(418, Self.ClassName, 'RetirarPapelSecundario', []);
         Result := -418;
         Exit;
       End;
       Q.Close;

       //--------------------------
       // Consiste Papel Secundário
       //--------------------------
       Q.SQL.Clear;
    {$IFDEF MSSQL}
       Q.SQL.Add('select 1 from tab_papel_secundario ');
       Q.SQL.Add(' where cod_papel_secundario = :cod_papel_secundario ');
       Q.SQL.Add('   and dta_fim_validade is null ');
    {$ENDIF}
       Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
       Q.Open;
       If Q.IsEmpty Then Begin
         Mensagens.Adicionar(422, Self.ClassName, 'RetirarPapelSecundario', []);
         Result := -422;
         Exit;
       End;
       Q.Close;

      //--------------------------------------------------------------------
      // Verifica se a pessoa é o criador de algum evento
      //--------------------------------------------------------------------
      if (CodPapelSecundario = 1) then begin
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_evento_venda_criador '+
                  ' where cod_pessoa_produtor = :cod_pessoa_produtor '+
                  '   and cod_pessoa_secundaria = :cod_pessoa ');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoaSecundaria;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(1025, Self.ClassName, 'RetirarPapelSecundario', []);
          Result := -1025;
          Exit;
        end;
        Q.Close;
      end;

      //--------------------------------------------------------------------
      // Verifica se a pessoa é o frigorífico ou aglomeração de algum animal
      //--------------------------------------------------------------------
      if (CodPapelSecundario = 2) or (CodPapelSecundario = 3) then begin
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_animal ' +
                  ' where cod_pessoa_produtor   = :cod_pessoa_produtor ' +
                  '   and cod_pessoa_secundaria_corrente = :cod_pessoa ' +
                  '   and dta_fim_validade is null ');
{$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_pessoa').AsInteger := CodPessoaSecundaria;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(842, Self.ClassName, 'RetirarPapelSecundario', []);
          Result := -842;
          Exit;
        end;
        Q.Close;
      end;

      //----------------------------------
      // Verifica existencia do registro
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa_papel_secundario ');
      Q.SQL.Add(' where cod_pessoa_produtor   = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_papel_secundario  = :cod_papel_secundario ');
      Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
      Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
      Q.Open;

      If not Q.IsEmpty Then Begin
        // Tenta Excluir Registro
        Q.Close;
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('delete from tab_pessoa_papel_secundario ');
        Q.SQL.Add(' where cod_pessoa_produtor   = :cod_pessoa_produtor ');
        Q.SQL.Add('   and cod_papel_secundario  = :cod_papel_secundario ');
        Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria ');
  {$ENDIF}
        Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
        Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
        Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
        Q.ExecSQL;
      end;

      // Retorna status OK
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(427, Self.ClassName, 'RetirarPapelSecundario', [E.Message]);
        Result := -427;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntPessoasSecundarias.PossuiPapelSecundario(CodPessoaSecundaria, CodPapelSecundario: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('PossuiPapelSecundario');
    Exit;
  End;
  //------------------------------------------
  // Verifica se usuário pode executar método
  //------------------------------------------
  If Not Conexao.PodeExecutarMetodo(141) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'PossuiPapelSecundario', []);
    Result := -188;
    Exit;
  End;
  //-----------------------------------------------
  // Verifica se produtor de trabalho foi definido
  //-----------------------------------------------
  If Conexao.CodProdutorTrabalho = -1 Then Begin
    Mensagens.Adicionar(307, Self.ClassName, 'PossuiPapelSecundario', []);
    Result := -307;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

     //----------------------------
     // Consiste Pessoa Secundária
     //----------------------------
       Q.SQL.Clear;
    {$IFDEF MSSQL}
       Q.SQL.Add('select 1 from tab_pessoa_secundaria ');
       Q.SQL.Add(' where cod_pessoa_produtor   = :cod_pessoa_produtor ');
       Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria ');
       Q.SQL.Add('   and dta_fim_validade is null ');
    {$ENDIF}
       Q.ParamByName('cod_pessoa_produtor').AsInteger := Conexao.CodProdutorTrabalho;
       Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
       Q.Open;
       If Q.IsEmpty Then Begin
         Mensagens.Adicionar(418, Self.ClassName, 'PossuiPapelSecundario', []);
         Result := -418;
         Exit;
       End;
       Q.Close;

       //--------------------------
       // Consiste Papel Secundário
       //--------------------------
       Q.SQL.Clear;
    {$IFDEF MSSQL}
       Q.SQL.Add('select 1 from tab_papel_secundario ');
       Q.SQL.Add(' where cod_papel_secundario = :cod_papel_secundario ');
       Q.SQL.Add('   and dta_fim_validade is null ');
    {$ENDIF}
       Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
       Q.Open;
       If Q.IsEmpty Then Begin
         Mensagens.Adicionar(422, Self.ClassName, 'PossuiPapelSecundario', []);
         Result := -422;
         Exit;
       End;
       Q.Close;

      //----------------------------------
      // Verifica existencia do registro
      //----------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_pessoa_papel_secundario ');
      Q.SQL.Add(' where cod_pessoa_produtor   = :cod_pessoa_produtor ');
      Q.SQL.Add('   and cod_papel_secundario  = :cod_papel_secundario ');
      Q.SQL.Add('   and cod_pessoa_secundaria = :cod_pessoa_secundaria ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger  := Conexao.CodProdutorTrabalho;
      Q.ParamByName('cod_papel_secundario').AsInteger := CodPapelSecundario;
      Q.ParamByName('cod_pessoa_secundaria').AsInteger := CodPessoaSecundaria;
      Q.Open;

      If not Q.IsEmpty Then Begin
        Result := 1;
      end
      else begin
        Result := 0;
      end;

    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(415, Self.ClassName, 'PossuiPapelSecundario', [E.Message]);
        Result := -415;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

end.
