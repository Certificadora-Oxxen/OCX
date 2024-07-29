// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Controle Acesso
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 25/07/2002
// *  Documentação       : Controle de acesso - definição das classes
// *  Código Classe      : 14
// *  Descrição Resumida : Cadastro de Acesso
// *
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    17/07/2002  Alterar o NumCNPJCPF adcionando Like no
// *                         Método PesquisarProdutores
// *   Hitalo   02/09/2002   Adicionar SglProdutor,QtdCaracterCodManejo
// *
// *
// ********************************************************************
unit uIntAcesso;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uConexao, uIntMensagens, uFerramentas,
     uIntUsuario, uIntItemMenu, uIntBloqueio, uIntParametro;

type
  { TIntAcesso }
  TIntAcesso = class(TIntClasseBDNavegacaoBasica)
  private
    FIntUsuario             : TIntUsuario;
    FIntItemMenu            : TIntItemMenu;
    FIntBloqueio            : TIntBloqueio;
    FIntParametro           : TIntParametro;
    FTipoAcesso             : String;
    function TrataErroLogin(CodUsuario: Integer): Integer;
    function TrataLoginCorreto(CodUsuario: Integer): Integer;
    function AtualizaBloqueio(CodUsuario: Integer): Integer;
    function ProdutorBloqueado(CodPessoaProdutor: Integer): Boolean;
    function AtualizaBloqueioProdutor(CodPessoaProdutor: Integer): Integer;
//    function AtualizaProdutor(CodPessoaProdutor: Integer): Integer;
    function CarregaMenus(CodPapel, CodPerfil: Integer): Integer;
    function CarregaFuncoes(CodPerfil: Integer): Integer;
    function CarregaMetodos(CodPerfil: Integer): Integer;
//    function VerificaLetraNumero(Str: String): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens; NomUsuario,
      TxtSenha: String): Integer; reintroduce; overload;

    procedure PesquisarItensMenu(CodItemPai, NumNivelMaximo: Integer);
    procedure BuscarProximoItemMenu;
    function EOFItensMenu: Boolean;

    function PodeExecutarFuncao(CodFuncao: Integer): Boolean;
    function QtdComunicadosNaoLidos: Integer;
    function QtdComunicadosImportantesNaoLidos: Integer;

    function PesquisarProdutores(CodProdutor: Integer; NomProdutor, CodNatureza,
      NumCNPJCPF: String) : Integer;
    procedure IrAoProximoProdutor;
    function ValorCampoProdutor(NomCampo: String): Variant;
    function EOFProdutores: Boolean;
    procedure FecharPesquisaProdutores;

    function DefinirProdutorTrabalho(CodProdutor: Integer): Integer;
    procedure LimparProdutorTrabalho;
    function ExisteProdutorTrabalho: Boolean;

    function DefinirFazendaTrabalho(CodFazenda: Integer): Integer;
    procedure LimparFazendaTrabalho;
    function ExisteFazendaTrabalho: Boolean;

    function AlterarUsuario(TxtSenhaAtual, NomUsuarioNovo, TxtSenhaNova,
      NomTratamentoNovo: String): Integer;

    procedure LimpaDadosAcesso;

    property IntUsuario : TIntUsuario           read FIntUsuario          write FIntUsuario;
    property IntItemMenu : TIntItemMenu         read FIntItemMenu         write FIntItemMenu;
    property IntBloqueio : TIntBloqueio         read FIntBloqueio         write FIntBloqueio;
    property TipoAcesso : String                read FTipoAcesso          write FTipoAcesso;
    property IntParametro : TIntParametro read FIntParametro write FIntParametro;
  end;

implementation

{ TIntAcesso }
constructor TIntAcesso.Create;
begin
  inherited;
  FIntUsuario := TIntUsuario.Create;
  FIntItemMenu := TIntItemMenu.Create;
  FIntBloqueio := TIntBloqueio.Create;
  FIntParametro := TIntParametro.Create;
end;

destructor TIntAcesso.Destroy;
begin
  if FIntUsuario <> nil then begin
    FIntUsuario.Free;
    FIntUsuario := nil;
  end;
  if FIntItemMenu <> nil then begin
    FIntItemMenu.Free;
    FIntItemMenu := nil;
  end;
  if FIntBloqueio <> nil then begin
    FIntBloqueio.Free;
    FIntBloqueio := nil;
  end;
  if FIntParametro <> nil then begin
    FIntParametro.Free;
    FIntParametro := nil;
  end;
  Conexao.LimpaProdutorTrabalho;
  Conexao.LimpaFazendaTrabalho;
  inherited;
end;

function TIntAcesso.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens; NomUsuario,
  TxtSenha: String): Integer;
var
  Q : THerdomQuery;
  Snh : String;
begin
  Result := (inherited Inicializar(ConexaoBD, Mensagens));

  if Result < 0 then Exit;

  // Limpa objetos periféricos
  if FIntUsuario <> nil then begin
    FIntUsuario.Free;
    FIntUsuario := nil;
  end;
  if FIntItemMenu <> nil then begin
    FIntItemMenu.Free;
    FIntItemMenu := nil;
  end;
  if FIntBloqueio <> nil then begin
    FIntBloqueio.Free;
    FIntBloqueio := nil;
  end;
  if FIntParametro <> nil then begin
    FIntParametro.Free;
    FIntParametro := nil;
  end;

  // Recria objetos periféricos
  FIntUsuario          := TIntUsuario.Create;
  FIntItemMenu         := TIntItemMenu.Create;
  FIntBloqueio         := TIntBloqueio.Create;
  FIntParametro        := TIntParametro.create;

  // Limpa dados armazenados no objeto conexão
  LimpaDadosAcesso;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      //-----------------------
      // Obtem dados do usuário
      //-----------------------
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tu.cod_usuario, ' +
      '       tu.nom_usuario, ' +
      '       tu.nom_tratamento, ' +
      '       tu.txt_senha, ' +
      '       tu.cod_pessoa, ' +
      '       tp.nom_pessoa, ' +
      '       tp.cod_natureza_pessoa, ' +
      '       tp.num_cnpj_cpf, ' +
      '       case tp.cod_natureza_pessoa ' +
      '         when ''F'' then convert(varchar(18), ' +
      '                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ' +
      '                             substring(tp.num_cnpj_cpf, 10, 2)) ' +
      '         when ''J'' then convert(varchar(18), ' +
      '                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ' +
      '                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ' +
      '                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ' +
      '                             substring(tp.num_cnpj_cpf, 13, 2)) ' +
      '       end as num_cnpj_cpf_formatado, ' +
      '       tu.cod_papel, ' +
      '       tpa.des_papel, ' +
      '       tpa.cod_tipo_acesso, ' +
      '       tu.cod_perfil, ' +
      '       tpe.nom_perfil, ' +
      '       tu.qtd_acum_logins_corretos, ' +
      '       tu.qtd_acum_logins_incorretos, ' +
      '       tu.dta_ultimo_login_correto, ' +
      '       tu.dta_ultimo_login_incorreto, ' +
      '       tu.qtd_logins_incorretos, ' +
      '       tu.ind_usuario_bloqueado, ' +
      '       tu.dta_criacao_usuario, ' +
      '       tpp.dta_fim_validade as dta_fim_validade_papel, ' +
      '       tp.nom_reduzido_pessoa,' +      
      '       tpe.dta_fim_validade as dta_fim_validade_perfil ' +
      '  from tab_usuario tu, ' +
      '       tab_pessoa tp, ' +
      '       tab_papel tpa, ' +
      '       tab_pessoa_papel tpp, ' +
      '       tab_perfil tpe ' +
      ' where tp.cod_pessoa = tu.cod_pessoa ' +
      '   and tpa.cod_papel = tu.cod_papel ' +
      '   and tpe.cod_perfil = tu.cod_perfil ' +
      '   and tpp.cod_pessoa = tu.cod_pessoa ' +
      '   and tpp.cod_papel = tu.cod_papel ' +
      '   and tpe.cod_papel = tu.cod_papel ' +
      '   and tu.dta_fim_validade is null ' +
      '   and nom_usuario = :nom_usuario ');
{$ENDIF}
      Q.ParamByName('nom_usuario').AsString := NomUsuario;
      Q.Open;
      //--------------------------------
      // Verifica existência do usuário
      //--------------------------------
      if Q.IsEmpty then begin
        Mensagens.Adicionar(208, Self.ClassName, 'Inicializar', []);
        Result := -208;
        Exit;
      end;

      // Atualiza objeto Usuario
      FIntUsuario.CodUsuario               := Q.FieldByName('cod_usuario').AsInteger;
      FIntUsuario.NomUsuario               := Q.FieldByName('nom_usuario').AsString;
      FIntUsuario.NomTratamento            := Q.FieldByName('nom_tratamento').AsString;
      FIntUsuario.CodPessoa                := Q.FieldByName('cod_pessoa').AsInteger;
      FIntUsuario.NomPessoa                := Q.FieldByName('nom_pessoa').AsString;
      FIntUsuario.CodNaturezaPessoa        := Q.FieldByName('cod_natureza_pessoa').AsString;
      FIntUsuario.NumCNPJCPF               := Q.FieldByName('num_cnpj_cpf').AsString;
      FIntUsuario.CodPapel                 := Q.FieldByName('cod_papel').AsInteger;
      FIntUsuario.DesPapel                 := Q.FieldByName('des_papel').AsString;
      FIntUsuario.CodPerfil                := Q.FieldByName('cod_perfil').AsInteger;
      FIntUsuario.DesPerfil                := Q.FieldByName('nom_perfil').AsString;
      FIntUsuario.QtdAcumLoginsCorretos    := Q.FieldByName('qtd_acum_logins_corretos').AsInteger;
      FIntUsuario.QtdAcumLoginsIncorretos  := Q.FieldByName('qtd_acum_logins_incorretos').AsInteger;
      FIntUsuario.DtaUltimoLoginCorreto    := Q.FieldByName('dta_ultimo_login_correto').AsDateTime;
      FIntUsuario.DtaUltimoLoginIncorreto  := Q.FieldByName('dta_ultimo_login_incorreto').AsDateTime;
      FIntUsuario.QtdLoginsIncorretos      := Q.FieldByName('qtd_logins_incorretos').AsInteger;
      FIntUsuario.DtaCriacaoUsuario        := Q.FieldByName('dta_criacao_usuario').AsDateTime;
      FIntUsuario.NumCNPJCPFFormatado      := Q.FieldByName('num_cnpj_cpf_formatado').AsString;
      FIntUsuario.DtaPenultimoLoginCorreto := Q.FieldByName('dta_ultimo_login_correto').AsDateTime;
      FIntUsuario.NomUsuarioReduzido       := Q.FieldByName('nom_reduzido_pessoa').AsString;

      // Atualiza propriedades CodUsuario e CodProdutor do objeto Conexao
      Conexao.CodUsuario := Q.FieldByName('cod_usuario').AsInteger;
      Conexao.CodPapelUsuario := Q.FieldByName('cod_papel').AsInteger;

      // Atualiza propriedade CodPessoa correspondente a pessoa do usuário
      Conexao.CodPessoa := Q.FieldByName('cod_pessoa').AsInteger;

      Conexao.CodProdutor := -1;

      // Atualiza propriedade TipoAcesso
      FTipoAcesso := Q.FieldByName('cod_tipo_acesso').AsString;
      Conexao.CodTipoAcesso := Q.FieldByName('cod_tipo_acesso').AsString;

      // Verifica se usuário está bloqueado, carregando objeto bloqueio
      // se usuário estiver bloqueado
      if Q.FieldByName('ind_usuario_bloqueado').AsString = 'S' then begin
        Result := AtualizaBloqueio(Q.FieldByName('cod_usuario').AsInteger);
        if Result = 0 then begin
          // Limpa dados armazenados no objeto conexão
          LimpaDadosAcesso;
          Mensagens.Adicionar(161, Self.ClassName, 'Inicializar', []);
          Result := -161;
        end;
        Exit;
      end;

      // Verifica Senha e atualiza totalizadores de logins corretos / incorretos
      Snh := UpperCase(Descriptografar(Q.FieldByName('txt_senha').AsString));
      if UpperCase(TxtSenha) <> Snh then begin
        Result := TrataErroLogin(Q.FieldByName('cod_usuario').AsInteger);
        // Limpa dados armazenados no objeto conexão
        LimpaDadosAcesso;
        Exit;
      end else begin
        Result := TrataLoginCorreto(Q.FieldByName('cod_usuario').AsInteger);
        if Result < 0 then begin
          // Limpa dados armazenados no objeto conexão
          LimpaDadosAcesso;
          Exit;
        end;
      end;

      // Verifica validade do perfil
      if not Q.FieldByName('dta_fim_validade_perfil').IsNull then begin
        // Limpa dados armazenados no objeto conexão
        LimpaDadosAcesso;
        Mensagens.Adicionar(162, Self.ClassName, 'Inicializar', []);
        Result := -162;
        Exit;
      end;

      // Verifica validade do papel
      if not Q.FieldByName('dta_fim_validade_papel').IsNull then begin
        // Limpa dados armazenados no objeto conexão
        LimpaDadosAcesso;
        Mensagens.Adicionar(163, Self.ClassName, 'Inicializar', []);
        Result := -163;
        Exit;
      end;

      // Verifica se é produtor e se o mesmo está bloqueado, carregando
      // objeto bloqueio se produtor estiver bloqueado
      if Q.FieldByName('cod_papel').AsInteger = 4 then begin
        Conexao.CodProdutor := Q.FieldByName('cod_pessoa').AsInteger;
        if ProdutorBloqueado(Q.FieldByName('cod_pessoa').AsInteger) then begin
          Result := AtualizaBloqueioProdutor(Q.FieldByName('cod_pessoa').AsInteger);
          if Result = 0 then begin
            // Limpa dados armazenados no objeto conexão
            LimpaDadosAcesso;
            Mensagens.Adicionar(181, Self.ClassName, 'Inicializar', []);
            Result := -181;
          end;
          Exit;
        end;

        // Atualiza objeto produtor
//        Result := AtualizaProdutor(Q.FieldByName('cod_pessoa').AsInteger);
        Result := DefinirProdutorTrabalho(Q.FieldByName('cod_pessoa').AsInteger);
        if Result < 0 then begin
          // Limpa dados armazenados no objeto conexão
          LimpaDadosAcesso;
          Exit;
        end;
      end;

      // Carrega Estrutura com menus disponíveis para o usuário
      Result := CarregaMenus(Q.FieldByName('cod_papel').AsInteger, Q.FieldByName('cod_perfil').AsInteger);
      if Result < 0 then begin
        // Limpa dados armazenados no objeto conexão
        LimpaDadosAcesso;
        Exit;
      end;
      // Carrega Estrutura com funções disponíveis para o usuário
      Result := CarregaFuncoes(Q.FieldByName('cod_perfil').AsInteger);
      if Result < 0 then begin
        // Limpa dados armazenados no objeto conexão
        LimpaDadosAcesso;
        Exit;
      end;
      // Carrega Estrutura com métodos disponíveis para o usuário
      Result := CarregaMetodos(Q.FieldByName('cod_perfil').AsInteger);
      if Result < 0 then begin
        // Limpa dados armazenados no objeto conexão
        LimpaDadosAcesso;
        Exit;
      end;

      Conexao.NomUsuario := FIntUsuario.NomUsuario;

      //--------------------------
      // Obtem dados do Parametro
      //--------------------------
      FIntParametro.CodPaisCertificadora  := StrToInt(valorParametro(6));

      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select nom_pais  ' +
                '     , cod_pais_sisbov ' +
                '     , cod_pais_sisbov ' +
                '  from tab_pais ' +
                ' where cod_pais = :cod_pais ');
{$ENDIF}
      Q.ParamByName('cod_pais').AsInteger := FIntParametro.CodPaisCertificadora;
      Q.Open;
      //----------------------------
      // Verifica existência do Pais
      //----------------------------
      if Q.IsEmpty then begin
        // Limpa dados armazenados no objeto conexão
        LimpaDadosAcesso;
        Mensagens.Adicionar(402, Self.ClassName, 'Inicializar', []);
        Result := -402;
        Exit;
      end;
      //---------------------
      // Atualiza objeto País
      //---------------------
      FIntParametro.NomPaisCertificadora           := Q.FieldByName('nom_pais').AsString;
      FIntParametro.CodPaisSisBovCertificadora     := Q.FieldByName('cod_pais_sisbov').AsInteger;

      FIntParametro.IndCodCertificadoraAutomatico  := valorParametro(8);

      Result := 0;
      Q.Close;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(164, Self.ClassName, 'Inicializar', [E.Message]);
        Result := -164;
        // Limpa dados armazenados no objeto conexão
        LimpaDadosAcesso;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

procedure TIntAcesso.PesquisarItensMenu(CodItemPai, NumNivelMaximo: Integer);
var
  X, XAux, NivelAux: Integer;
begin
  if not Inicializado then begin
    RaiseNaoInicializado('PesquisarItensMenu');
    Exit;
  end;

  // Limpa coleção pesquisa
  Conexao.ItensMenuPesquisa.Clear;
  Conexao.PonteiroPesquisa := 0;

  // Limpa Objeto ItemMenu
  FIntItemMenu.CodItemMenu := 0;
  FIntItemMenu.TxtTitulo := '';
  FIntItemMenu.TxtHintItemMenu := '';
  FIntItemMenu.IndDestaqueTitulo := '';
  FIntItemMenu.CodItemPai := 0;
  FIntItemMenu.NumOrdem := 0;
  FIntItemMenu.NumNivel := 0;
  FIntItemMenu.QtdFilhos := 0;
  FIntItemMenu.CodPagina := 0;
  FIntItemMenu.URLPagina := '';

  // Trata parâmetros
  if NumNivelMaximo < 0 then begin
    NumNivelMaximo := 9999999;
  end;
  if CodItemPai < 0 then begin
    CodItemPai := 0;
  end;

  // Localiza o item de menu pai de acordo com parâmetro informado
  NivelAux := 0;
  XAux := 0;
  For X := 0 to Conexao.ItensMenuDisponiveis.Count - 1 do begin
    if CodItemPai = 0 then begin
      if Conexao.ItensMenuDisponiveis.Items[X].CodItemPai = CodItemPai then begin
        NivelAux := Conexao.ItensMenuDisponiveis.Items[X].NumNivel;
        XAux := X;
        Conexao.ItensMenuPesquisa.Add(Conexao.ItensMenuDisponiveis.Items[X].CodItemMenu,
                                      Conexao.ItensMenuDisponiveis.Items[X].TxtTitulo,
                                      Conexao.ItensMenuDisponiveis.Items[X].TxtHintItemMenu,
                                      Conexao.ItensMenuDisponiveis.Items[X].IndDestaqueTitulo,
                                      Conexao.ItensMenuDisponiveis.Items[X].CodItemPai,
                                      Conexao.ItensMenuDisponiveis.Items[X].NumOrdem,
                                      Conexao.ItensMenuDisponiveis.Items[X].NumNivel,
                                      Conexao.ItensMenuDisponiveis.Items[X].QtdFilhos,
                                      Conexao.ItensMenuDisponiveis.Items[X].CodPagina,
                                      Conexao.ItensMenuDisponiveis.Items[X].URLPagina);
        Break;
      end;
    end else begin
      if Conexao.ItensMenuDisponiveis.Items[X].CodItemMenu = CodItemPai then begin
        NivelAux := Conexao.ItensMenuDisponiveis.Items[X].NumNivel;
        XAux := X;
        Conexao.ItensMenuPesquisa.Add(Conexao.ItensMenuDisponiveis.Items[X].CodItemMenu,
                                      Conexao.ItensMenuDisponiveis.Items[X].TxtTitulo,
                                      Conexao.ItensMenuDisponiveis.Items[X].TxtHintItemMenu,
                                      Conexao.ItensMenuDisponiveis.Items[X].IndDestaqueTitulo,
                                      Conexao.ItensMenuDisponiveis.Items[X].CodItemPai,
                                      Conexao.ItensMenuDisponiveis.Items[X].NumOrdem,
                                      Conexao.ItensMenuDisponiveis.Items[X].NumNivel,
                                      Conexao.ItensMenuDisponiveis.Items[X].QtdFilhos,
                                      Conexao.ItensMenuDisponiveis.Items[X].CodPagina,
                                      Conexao.ItensMenuDisponiveis.Items[X].URLPagina);
        Break;
      end;
    end;
  end;

  if NivelAux = 0 then begin
    Conexao.PonteiroPesquisa := 9999999;
    Exit;
  end;

//  if NivelAux = 0 then Exit;

  if CodItemPai = 0 then NivelAux := -1;
  // Preenche coleção pesquisa com restante dos itens descendentes do menu pai encontrado
  For X := XAux to Conexao.ItensMenuDisponiveis.Count - 1 do begin
    if X > XAux then begin
      if (Conexao.ItensMenuDisponiveis.Items[X].NumNivel > NivelAux) and
         (Conexao.ItensMenuDisponiveis.Items[X].NumNivel < NumNivelMaximo) then begin
        Conexao.ItensMenuPesquisa.Add(Conexao.ItensMenuDisponiveis.Items[X].CodItemMenu,
                                      Conexao.ItensMenuDisponiveis.Items[X].TxtTitulo,
                                      Conexao.ItensMenuDisponiveis.Items[X].TxtHintItemMenu,
                                      Conexao.ItensMenuDisponiveis.Items[X].IndDestaqueTitulo,
                                      Conexao.ItensMenuDisponiveis.Items[X].CodItemPai,
                                      Conexao.ItensMenuDisponiveis.Items[X].NumOrdem,
                                      Conexao.ItensMenuDisponiveis.Items[X].NumNivel,
                                      Conexao.ItensMenuDisponiveis.Items[X].QtdFilhos,
                                      Conexao.ItensMenuDisponiveis.Items[X].CodPagina,
                                      Conexao.ItensMenuDisponiveis.Items[X].URLPagina);
      end;
    end;
  end;

  // Atribui primeiro item da coleção pesquisa ao objeto menu
  FIntItemMenu.CodItemMenu       := Conexao.ItensMenuPesquisa.Items[Conexao.PonteiroPesquisa].CodItemMenu;
  FIntItemMenu.TxtTitulo         := Conexao.ItensMenuPesquisa.Items[Conexao.PonteiroPesquisa].TxtTitulo;
  FIntItemMenu.TxtHintItemMenu   := Conexao.ItensMenuPesquisa.Items[Conexao.PonteiroPesquisa].TxtHintItemMenu;
  FIntItemMenu.IndDestaqueTitulo := Conexao.ItensMenuPesquisa.Items[Conexao.PonteiroPesquisa].IndDestaqueTitulo;
  FIntItemMenu.CodItemPai        := Conexao.ItensMenuPesquisa.Items[Conexao.PonteiroPesquisa].CodItemPai;
  FIntItemMenu.NumOrdem          := Conexao.ItensMenuPesquisa.Items[Conexao.PonteiroPesquisa].NumOrdem;
  FIntItemMenu.NumNivel          := Conexao.ItensMenuPesquisa.Items[Conexao.PonteiroPesquisa].NumNivel;
  FIntItemMenu.QtdFilhos         := Conexao.ItensMenuPesquisa.Items[Conexao.PonteiroPesquisa].QtdFilhos;
  FIntItemMenu.CodPagina         := Conexao.ItensMenuPesquisa.Items[Conexao.PonteiroPesquisa].CodPagina;
  FIntItemMenu.URLPagina         := Conexao.ItensMenuPesquisa.Items[Conexao.PonteiroPesquisa].URLPagina;

  Conexao.PonteiroPesquisa := 1;
end;

procedure TIntAcesso.BuscarProximoItemMenu;
var
  Indice : Integer;
begin
  if not Inicializado then begin
    RaiseNaoInicializado('BuscarProximoItemMenu');
    Exit;
  end;

  if Conexao.PonteiroPesquisa < Conexao.ItensMenuPesquisa.Count then begin
    Indice := Conexao.PonteiroPesquisa;
  end else begin
    Indice := Conexao.ItensMenuPesquisa.Count - 1;
  end;

  if Conexao.PonteiroPesquisa < Conexao.ItensMenuPesquisa.Count then begin
    FIntItemMenu.CodItemMenu       := Conexao.ItensMenuPesquisa.Items[Indice].CodItemMenu;
    FIntItemMenu.TxtTitulo         := Conexao.ItensMenuPesquisa.Items[Indice].TxtTitulo;
    FIntItemMenu.TxtHintItemMenu   := Conexao.ItensMenuPesquisa.Items[Indice].TxtHintItemMenu;
    FIntItemMenu.IndDestaqueTitulo := Conexao.ItensMenuPesquisa.Items[Indice].IndDestaqueTitulo;
    FIntItemMenu.CodItemPai        := Conexao.ItensMenuPesquisa.Items[Indice].CodItemPai;
    FIntItemMenu.NumOrdem          := Conexao.ItensMenuPesquisa.Items[Indice].NumOrdem;
    FIntItemMenu.NumNivel          := Conexao.ItensMenuPesquisa.Items[Indice].NumNivel;
    FIntItemMenu.QtdFilhos         := Conexao.ItensMenuPesquisa.Items[Indice].QtdFilhos;
    FIntItemMenu.CodPagina         := Conexao.ItensMenuPesquisa.Items[Indice].CodPagina;
    FIntItemMenu.URLPagina         := Conexao.ItensMenuPesquisa.Items[Indice].URLPagina;
  end;
  Conexao.PonteiroPesquisa := Conexao.PonteiroPesquisa + 1;
end;

function TIntAcesso.EOFItensMenu: Boolean;
begin
  if not Inicializado then begin
    RaiseNaoInicializado('EOFItensMenu');
    Result := True;
    Exit;
  end;

  Result := Conexao.PonteiroPesquisa > Conexao.ItensMenuPesquisa.Count;
end;

function TIntAcesso.PodeExecutarFuncao(CodFuncao: Integer): Boolean;
begin
  if not Inicializado then begin
    RaiseNaoInicializado('PodeExecutarFuncao');
    Result := False;
    Exit;
  end;

  Result := Conexao.GetFuncao(CodFuncao);
end;

function TIntAcesso.PesquisarProdutores(CodProdutor: Integer; NomProdutor, CodNatureza,
      NumCNPJCPF: String) : Integer;
begin
  Result := -1;

  if not Inicializado then
  begin
    RaiseNaoInicializado('PesquisarProdutores');
    Exit;
  end;

  Query.Close;
  Query.SQL.Clear;
  {$IFDEF MSSQL}
  Query.SQL.Add('select tp.cod_pessoa as CodPessoa, ');
  Query.SQL.Add('       tp.nom_pessoa as NomPessoa, ');
  Query.SQL.Add('       tp.cod_natureza_pessoa as CodNaturezaPessoa, ');
  Query.SQL.Add('       tp.num_cnpj_cpf as NumCNPJCPF, ');
  Query.SQL.Add('       case tp.cod_natureza_pessoa ');
  Query.SQL.Add('         when ''F'' then convert(varchar(18), ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 10, 2)) ');
  Query.SQL.Add('         when ''J'' then convert(varchar(18), ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ');
  Query.SQL.Add('                             substring(tp.num_cnpj_cpf, 13, 2)) ');
  Query.SQL.Add('       end as NumCNPJCPFFormatado ');
  Query.SQL.Add('  from tab_pessoa tp, ');
  Query.SQL.Add('       tab_produtor tpro, ');

  if FIntUsuario.CodPapel = 1 then // Associação
  begin
    Query.SQL.Add('       tab_associacao_produtor tap, ');
  end
  else if FIntUsuario.CodPapel = 3 then // Tecnico
  begin
    Query.SQL.Add('       tab_tecnico_produtor ttp, ');
  end;

  Query.SQL.Add('       tab_pessoa_papel tpp ');
  Query.SQL.Add(' where tpp.cod_pessoa = tp.cod_pessoa ');
  Query.SQL.Add('   and tpro.cod_pessoa_produtor = tp.cod_pessoa ');
  Query.SQL.Add('   and tpro.dta_fim_validade is null ');
  Query.SQL.Add('   and tpp.dta_fim_validade is null ');

  if FIntUsuario.CodPapel = 1 then // Associação
  begin
    Query.SQL.Add('  and tap.cod_pessoa_produtor = tp.cod_pessoa ');
    Query.SQL.Add('  and tap.cod_pessoa_associacao = :cod_pessoa_associacao ');
  end
  else if FIntUsuario.CodPapel = 3 then // Tecnico
  begin
    Query.SQL.Add('  and ttp.cod_pessoa_produtor = tp.cod_pessoa ');
    Query.SQL.Add('  and ttp.cod_pessoa_tecnico = :cod_pessoa_tecnico ');
    Query.SQL.Add('  and tpro.ind_produtor_bloqueado = ''N'' ');
    Query.SQL.Add('  and ttp.dta_fim_validade is null ');
  end
  else if FIntUsuario.CodPapel = 4 then // Produtor
  begin
    Query.SQL.Add('  and tp.cod_pessoa = :cod_pessoa_produtor ');
    Query.SQL.Add('  and tpro.ind_produtor_bloqueado = ''N'' ');
  end
  else if FIntUsuario.CodPapel = 9 then
  begin
    Query.SQL.Add('  and tp.cod_pessoa in ( select ttp.cod_pessoa_produtor as cod_pessoa ' +
                  '                           from tab_tecnico_produtor ttp ' +
                  '                              , tab_tecnico tt ' +
                  '                          where ttp.cod_pessoa_tecnico = tt.cod_pessoa_tecnico ' +
                  '                             and ttp.dta_fim_validade is null ' +
                  '                             and tt.dta_fim_validade is null ' +
                  '                             and tt.cod_pessoa_gestor = :cod_pessoa_gestor ' +
                  '                       ) ');
    Query.ParamByName('cod_pessoa_gestor').AsInteger :=  Conexao.CodPessoa;
  end;

  Query.SQL.Add('   and tpp.cod_papel = 4 ');
  Query.SQL.Add('   and tp.dta_fim_validade is null ');
  Query.SQL.Add('   and ((tp.cod_pessoa = :cod_produtor) or (:cod_produtor = -1)) ');

  if NomProdutor <> '' then
  begin
    Query.SQL.Add('   and tp.nom_pessoa like :nom_produtor ');
  end;
  if (CodNatureza = 'F') or (CodNatureza = 'J') then
  begin
    Query.SQL.Add('   and tp.cod_natureza_pessoa = :cod_natureza ');
  end;
  if NumCNPJCPF <> '' then
  begin
    Query.SQL.Add('   and tp.num_cnpj_cpf like :num_cnpj_cpf ');
  end;
  Query.SQL.Add(' order by tp.nom_pessoa ');
  {$ENDIF}

  if FIntUsuario.CodPapel = 1 then // Associação
  begin
    Query.ParamByName('cod_pessoa_associacao').AsInteger := FIntUsuario.CodPessoa;
  end
  else if FIntUsuario.CodPapel = 3 then // Tecnico
  begin
    Query.ParamByName('cod_pessoa_tecnico').AsInteger := FIntUsuario.CodPessoa;
  end
  else if FIntUsuario.CodPapel = 4 then // Produtor
  begin
    Query.ParamByName('cod_pessoa_produtor').AsInteger := FIntUsuario.CodPessoa;
  end;

  Query.ParamByName('cod_produtor').AsInteger := CodProdutor;

  if NomProdutor <> '' then
  begin
    Query.ParamByName('nom_produtor').AsString := NomProdutor + '%';
  end;
  if (CodNatureza = 'F') or (CodNatureza = 'J') then
  begin
    Query.ParamByName('cod_natureza').AsString := CodNatureza;
  end;
  if NumCNPJCPF <> '' then
  begin
    Query.ParamByName('num_cnpj_cpf').AsString := trim(NumCNPJCPF) + '%';
  end;

  try
    Query.Open;
    Result := 0;
  except
    on E: exception do begin
      Mensagens.Adicionar(179, Self.ClassName, 'PesquisarProdutores', [E.Message]);
      Result := -179;
      Exit;
    end;
  end;
end;

procedure TIntAcesso.IrAoProximoProdutor;
begin
  IrAoProximo;
end;

function TIntAcesso.ValorCampoProdutor(NomCampo: String): Variant;
begin
  Result := Valorcampo(NomCampo);
end;

function TIntAcesso.EOFProdutores: Boolean;
begin
  Result := EOF;
end;

procedure TIntAcesso.FecharPesquisaProdutores;
begin
  FecharPesquisa;
end;

function TIntAcesso.DefinirProdutorTrabalho(CodProdutor: Integer): Integer;
var
  sNomeProdutorBloqueado: String;
begin
  Result := -1;
  if not Inicializado then
  begin
    RaiseNaoInicializado('DefinirProdutorTrabalho');
    Exit;
  end;

  try
    Result := Conexao.DefinirProdutorTrabalho(CodProdutor, sNomeProdutorBloqueado);
    case Result of
      180: {Inexistência de dados do produtor}
      begin
        Mensagens.Adicionar(180, Self.ClassName, 'DefinirProdutorTrabalho', [IntToStr(CodProdutor)]);
        Result := -180;
        Exit;
      end;
      362: {Dados do produtor obtidos, porém o mesmo está bloqueado (acesso negado)}
      begin
        Mensagens.Adicionar(362, Self.ClassName, 'DefinirProdutorTrabalho', [sNomeProdutorBloqueado]);
        Result := -362;
        Exit;
      end;
      0: {Procedimento bem sucedido}
        Result := 0;
    else
      Exit;
    end;
  except
    on E: exception do
    begin
      Mensagens.Adicionar(171, Self.ClassName, 'DefinirProdutorTrabalho', [E.Message]);
      Result := -171;
      Exit;
    end;
  end;
end;

procedure TIntAcesso.LimparProdutorTrabalho;
begin
  if not Inicializado then begin
    RaiseNaoInicializado('LimparProdutorTrabalho');
    Exit;
  end;
  LimparFazendaTrabalho;
  Conexao.LimpaProdutorTrabalho;
end;

function TIntAcesso.ExisteProdutorTrabalho: Boolean;
begin
  Result := False;
  if not Inicializado then begin
    RaiseNaoInicializado('ExisteProdutorTrabalho');
    Exit;
  end;
  Result := Conexao.ExisteProdutorTrabalho;
end;

function TIntAcesso.AtualizaBloqueio(CodUsuario: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Obtem dados do bloqueio
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tbu.dta_inicio_bloqueio, ');
      Q.SQL.Add('       tbu.dta_fim_bloqueio, ');
      Q.SQL.Add('       tbu.cod_motivo_bloqueio, ');
      Q.SQL.Add('       tmb.cod_aplicacao_bloqueio, ');
      Q.SQL.Add('       tmb.txt_motivo_usuario, ');
      Q.SQL.Add('       tmb.des_motivo_bloqueio, ');
      Q.SQL.Add('       tbu.txt_observacao_bloqueio, ');
      Q.SQL.Add('       tbu.txt_observacao_usuario, ');
      Q.SQL.Add('       tbu.txt_procedimento_usuario, ');
      Q.SQL.Add('       tbu.cod_usuario_insercao, ');
      Q.SQL.Add('       tur.nom_usuario as nom_usuario_insercao, ');
      Q.SQL.Add('       tub.nom_usuario ');
      Q.SQL.Add('  from tab_bloqueio_usuario tbu, ');
      Q.SQL.Add('       tab_motivo_bloqueio tmb, ');
      Q.SQL.Add('       tab_usuario tur, ');
      Q.SQL.Add('       tab_usuario tub ');
      Q.SQL.Add(' where tmb.cod_motivo_bloqueio = tbu.cod_motivo_bloqueio ');
      Q.SQL.Add('   and tur.cod_usuario = tbu.cod_usuario_insercao ');
      Q.SQL.Add('   and tub.cod_usuario = tbu.cod_usuario ');
      Q.SQL.Add('   and tbu.cod_usuario = :cod_usuario ');
      Q.SQL.Add('   and tbu.dta_fim_bloqueio is null');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.Open;

      // Verifica existência de dados do bloqueio
      if Q.IsEmpty then begin
        Mensagens.Adicionar(167, Self.ClassName, 'AtualizaBloqueio', [IntToStr(CodUsuario)]);
        Result := -167;
        Exit;
      end;

      FIntBloqueio.CodAplicacaoBloqueio   := Q.FieldByName('cod_aplicacao_bloqueio').AsString;
      FIntBloqueio.CodUsuario             := CodUsuario;
      FIntBloqueio.CodPessoaProdutor      := -1;
      FIntBloqueio.DtaInicioBloqueio      := Q.FieldByName('dta_inicio_bloqueio').AsDateTime;
      FIntBloqueio.DtaFimBloqueio         := Q.FieldByName('dta_fim_bloqueio').AsDateTime;
      FIntBloqueio.CodMotivoBloqueio      := Q.FieldByName('cod_motivo_bloqueio').AsInteger;
      FIntBloqueio.TxtMotivoBloqueio      := Q.FieldByName('des_motivo_bloqueio').AsString;
      FIntBloqueio.TxtObservacaoBloqueio  := ''; //Q.FieldByName('txt_observacao_bloqueio').AsString;
      FIntBloqueio.TxtMotivoUsuario       := Q.FieldByName('txt_motivo_usuario').AsString;
      FIntBloqueio.TxtObservacaoUsuario   := Q.FieldByName('txt_observacao_usuario').AsString;
      FIntBloqueio.TxtProcedimentoUsuario := Q.FieldByName('txt_procedimento_usuario').AsString;
      FIntBloqueio.CodUsuarioResponsavel  := Q.FieldByName('cod_usuario_insercao').AsInteger;
      FIntBloqueio.NomUsuarioResponsavel  := Q.FieldByName('nom_usuario_insercao').AsString;
      FIntBloqueio.NomUsuario             := Q.FieldByName('nom_usuario').AsString;
      FIntBloqueio.NomPessoa              := '';

      Result := 0;
      Q.Close;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(165, Self.ClassName, 'AtualizaBloqueio', [E.Message]);
        Result := -165;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntAcesso.AtualizaBloqueioProdutor(
  CodPessoaProdutor: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Obtem dados do bloqueio
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tbp.dta_inicio_bloqueio, ');
      Q.SQL.Add('       tbp.dta_fim_bloqueio, ');
      Q.SQL.Add('       tbp.cod_motivo_bloqueio, ');
      Q.SQL.Add('       tmb.cod_aplicacao_bloqueio, ');
      Q.SQL.Add('       tmb.txt_motivo_usuario, ');
      Q.SQL.Add('       tmb.des_motivo_bloqueio, ');
      Q.SQL.Add('       tbp.txt_observacao_bloqueio, ');
      Q.SQL.Add('       tbp.txt_observacao_usuario, ');
      Q.SQL.Add('       tbp.txt_procedimento_usuario, ');
      Q.SQL.Add('       tbp.cod_usuario_insercao, ');
      Q.SQL.Add('       tur.nom_usuario as nom_usuario_insercao, ');
      Q.SQL.Add('       tp.nom_pessoa ');
      Q.SQL.Add('  from tab_bloqueio_produtor tbp, ');
      Q.SQL.Add('       tab_motivo_bloqueio tmb, ');
      Q.SQL.Add('       tab_usuario tur, ');
      Q.SQL.Add('       tab_pessoa tp ');
      Q.SQL.Add(' where tmb.cod_motivo_bloqueio = tbp.cod_motivo_bloqueio ');
      Q.SQL.Add('   and tur.cod_usuario = tbp.cod_usuario_insercao ');
      Q.SQL.Add('   and tp.cod_pessoa = tbp.cod_pessoa_produtor ');
      Q.SQL.Add('   and tbp.cod_pessoa_produtor = :cod_pessoa_produtor ');
      Q.SQL.Add('   and getdate() >= tbp.dta_inicio_bloqueio and tbp.dta_fim_bloqueio is null');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;

      // Verifica existência de dados do bloqueio
      if Q.IsEmpty then begin
        Mensagens.Adicionar(168, Self.ClassName, 'AtualizaBloqueioProdutor', [IntToStr(CodPessoaProdutor)]);
        Result := -168;
        Exit;
      end;

      FIntBloqueio.CodAplicacaoBloqueio   := Q.FieldByName('cod_aplicacao_bloqueio').AsString;
      FIntBloqueio.CodUsuario             := -1;
      FIntBloqueio.CodPessoaProdutor      := CodPessoaProdutor;
      FIntBloqueio.DtaInicioBloqueio      := Q.FieldByName('dta_inicio_bloqueio').AsDateTime;
      FIntBloqueio.DtaFimBloqueio         := Q.FieldByName('dta_fim_bloqueio').AsDateTime;
      FIntBloqueio.CodMotivoBloqueio      := Q.FieldByName('cod_motivo_bloqueio').AsInteger;
      FIntBloqueio.TxtMotivoBloqueio      := Q.FieldByName('des_motivo_bloqueio').AsString;
      FIntBloqueio.TxtObservacaoBloqueio  := ''; //Q.FieldByName('txt_observacao_bloqueio').AsString;
      FIntBloqueio.TxtMotivoUsuario       := Q.FieldByName('txt_motivo_usuario').AsString;
      FIntBloqueio.TxtObservacaoUsuario   := Q.FieldByName('txt_observacao_usuario').AsString;
      FIntBloqueio.TxtProcedimentoUsuario := Q.FieldByName('txt_procedimento_usuario').AsString;
      FIntBloqueio.CodUsuarioResponsavel  := Q.FieldByName('cod_usuario_insercao').AsInteger;
      FIntBloqueio.NomUsuarioResponsavel  := Q.FieldByName('nom_usuario_insercao').AsString;
      FIntBloqueio.NomUsuario             := '';
      FIntBloqueio.NomPessoa              := Q.FieldByName('nom_pessoa').AsString;



      Result := 0;
      Q.Close;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(166, Self.ClassName, 'AtualizaBloqueioProdutor', [E.Message]);
        Result := -166;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntAcesso.ProdutorBloqueado(CodPessoaProdutor: Integer): Boolean;
var
  Q : THerdomQuery;
begin
  Result := True;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ind_produtor_bloqueado ');
      Q.SQL.Add('  from tab_produtor ');
      Q.SQL.Add(' where cod_pessoa_produtor = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;

      if Q.IsEmpty then begin
        Exit;
      end;

      if Q.FieldByName('ind_produtor_bloqueado').AsString = 'N' then begin
        Result := False;
      end;

      Q.Close;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(169, Self.ClassName, 'ProdutorBloqueado', [E.Message]);
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

(* Fábio - 06/10/2004 - Este método não esta mais sendo usado.
function TIntAcesso.AtualizaProdutor(CodPessoaProdutor: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Obtem dados do produtor
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tp.cod_pessoa, ');
      Q.SQL.Add('       tp.nom_pessoa, ');
      Q.SQL.Add('       tp.cod_natureza_pessoa, ');
      Q.SQL.Add('       tp.num_cnpj_cpf, ');
      Q.SQL.Add('       case tp.cod_natureza_pessoa ');
      Q.SQL.Add('         when ''F'' then convert(varchar(18), ');
      Q.SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 3) + ''.'' + ');
      Q.SQL.Add('                             substring(tp.num_cnpj_cpf, 4, 3) + ''.'' + ');
      Q.SQL.Add('                             substring(tp.num_cnpj_cpf, 7, 3) + ''-'' + ');
      Q.SQL.Add('                             substring(tp.num_cnpj_cpf, 10, 2)) ');
      Q.SQL.Add('         when ''J'' then convert(varchar(18), ');
      Q.SQL.Add('                             substring(tp.num_cnpj_cpf, 1, 2) + ''.'' + ');
      Q.SQL.Add('                             substring(tp.num_cnpj_cpf, 3, 3) + ''.'' + ');
      Q.SQL.Add('                             substring(tp.num_cnpj_cpf, 6, 3) + ''/'' + ');
      Q.SQL.Add('                             substring(tp.num_cnpj_cpf, 9, 4) + ''-'' + ');
      Q.SQL.Add('                             substring(tp.num_cnpj_cpf, 13, 2)) ');
      Q.SQL.Add('       end as num_cnpj_cpf_formatado, ');
      Q.SQL.Add('       tpp.dta_fim_validade as dta_fim_validade_papel ');
      Q.SQL.Add('  from tab_pessoa tp, ');
      Q.SQL.Add('       tab_pessoa_papel tpp ');
      Q.SQL.Add(' where tpp.cod_pessoa = tp.cod_pessoa ');
      Q.SQL.Add('   and tpp.cod_papel = 4 ');
      Q.SQL.Add('   and tp.dta_fim_validade is null ');
      Q.SQL.Add('   and tp.cod_pessoa = :cod_pessoa_produtor ');
{$ENDIF}
      Q.ParamByName('cod_pessoa_produtor').AsInteger := CodPessoaProdutor;
      Q.Open;

      // Verifica existência de dados da pessoa (produtor)
      if Q.IsEmpty then begin
        Mensagens.Adicionar(170, Self.ClassName, 'AtualizaProdutor', [IntToStr(CodPessoaProdutor)]);
        Result := -170;
        Exit;
      end;

      // Verifica validade do papel produtor para a pessoa
      if not Q.FieldByName('dta_fim_validade_papel').IsNull then begin
        Mensagens.Adicionar(163, Self.ClassName, 'AtualizaProdutor', []);
        Result := -163;
        Exit;
      end;

      // Atribui dados do produtor ao objeto Produtor
      Conexao.ProdutorTrabalho.CodProdutor         := Q.FieldByName('cod_pessoa').AsInteger;
      Conexao.ProdutorTrabalho.NomProdutor         := Q.FieldByName('nom_pessoa').AsString;
      Conexao.ProdutorTrabalho.CodNatureza         := Q.FieldByName('cod_natureza_pessoa').AsString;
      Conexao.ProdutorTrabalho.NumCPFCNPJ          := Q.FieldByName('num_cnpj_cpf').AsString;
      Conexao.ProdutorTrabalho.NumCPFCNPJFormatado := Q.FieldByName('num_cnpj_cpf_formatado').AsString;
      Conexao.CodProdutorTrabalho := Conexao.ProdutorTrabalho.CodProdutor;
      Conexao.ExisteProdutorTrabalho := True;
      Result := 0;
      Q.Close;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(171, Self.ClassName, 'AtualizaProdutor', [E.Message]);
        Result := -171;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;
*)

function TIntAcesso.CarregaMenus(CodPapel, CodPerfil: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Obtem dados de menu para o perfil
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tim.cod_item_menu, ');
      Q.SQL.Add('       tim.txt_titulo, ');
      Q.SQL.Add('       tim.txt_hint_item_menu, ');
      Q.SQL.Add('       tim.ind_destaque_titulo, ');
      Q.SQL.Add('       isnull(tim.cod_item_pai, 0) as cod_item_pai, ');
      Q.SQL.Add('       tim.num_ordem, ');
      Q.SQL.Add('       tim.num_nivel, ');
      Q.SQL.Add('       tim.qtd_filhos, ');
      Q.SQL.Add('       tim.cod_pagina, ');
      Q.SQL.Add('       tpar.val_parametro_sistema + ''/'' + (select des_caminho ');
      Q.SQL.Add('                                               from tab_caminho ');
      Q.SQL.Add('                                              where cod_caminho = tp.cod_caminho) ');
      Q.SQL.Add('                                  + ''/'' + tp.nom_arquivo as url_pagina ');
      Q.SQL.Add('  from tab_item_menu tim, ');
      Q.SQL.Add('       tab_pagina tp, ');
      Q.SQL.Add('       tab_parametro_sistema tpar, ');
      Q.SQL.Add('       tab_perfil_item_menu tpim ');
      Q.SQL.Add(' where tim.cod_papel = tpim.cod_papel ');
      Q.SQL.Add('   and tim.cod_item_menu = tpim.cod_item_menu ');
      Q.SQL.Add('   and tp.cod_pagina =* tim.cod_pagina ');
      Q.SQL.Add('   and tpar.cod_parametro_sistema = 2 ');
      Q.SQL.Add('   and tpim.cod_perfil = :cod_perfil ');
      Q.SQL.Add('   and tpim.cod_papel = :cod_papel ');
      Q.SQL.Add(' order by tim.num_ordem ');
{$ENDIF}
      Q.ParamByName('cod_papel').AsInteger := CodPapel;
      Q.ParamByName('cod_perfil').AsInteger := CodPerfil;
      Q.Open;

      // Carrega Coleção de Menus do Usuário
      Conexao.ItensMenuDisponiveis.Clear;
      Conexao.ItensMenuPesquisa.Clear;
      While not Q.EOF do begin
        Conexao.ItensMenuDisponiveis.Add(Q.FieldByName('cod_item_menu').AsInteger,
                                         Q.FieldByName('txt_titulo').AsString,
                                         Q.FieldByName('txt_hint_item_menu').AsString,
                                         Q.FieldByName('ind_destaque_titulo').AsString,
                                         Q.FieldByName('cod_item_pai').AsInteger,
                                         Q.FieldByName('num_ordem').AsInteger,
                                         Q.FieldByName('num_nivel').AsInteger,
                                         Q.FieldByName('qtd_filhos').AsInteger,
                                         Q.FieldByName('cod_pagina').AsInteger,
                                         Q.FieldByName('url_pagina').AsString);

        Q.Next;
      end;
      Result := 0;
      Q.Close;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(172, Self.ClassName, 'CarregaMenus', [E.Message]);
        Result := -172;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntAcesso.CarregaFuncoes(CodPerfil: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Obtem dados de menu para o perfil
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tf.cod_funcao ');
      Q.SQL.Add('  from tab_perfil_funcao tpf, ');
      Q.SQL.Add('       tab_funcao tf ');
      Q.SQL.Add(' where tf.cod_funcao = tpf.cod_funcao ');
      Q.SQL.Add('   and tf.dta_fim_validade is null ');
      Q.SQL.Add('   and tpf.cod_perfil = :cod_perfil ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := CodPerfil;
      Q.Open;

      // Carrega Funções disponíveis para o usuário
      Conexao.LimpaFuncoes;
      While not Q.EOF do begin
        if Conexao.SetFuncao(Q.FieldByName('cod_funcao').AsInteger, True) < 0 then begin
          Mensagens.Adicionar(173, Self.ClassName, 'CarregaFuncoes', [Q.FieldByName('cod_funcao').AsInteger]);
          Result := -173;
          Exit;
        end;
        Q.Next;
      end;
      Result := 0;
      Q.Close;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(175, Self.ClassName, 'CarregaFuncoes', [E.Message]);
        Result := -175;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntAcesso.CarregaMetodos(CodPerfil: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Obtem dados de menu para o perfil
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select distinct tm.cod_metodo ');
      Q.SQL.Add('  from tab_metodo tm, ');
      Q.SQL.Add('       tab_funcao_metodo tfm, ');
      Q.SQL.Add('       tab_perfil_funcao tpf, ');
      Q.SQL.Add('       tab_funcao tf ');
      Q.SQL.Add(' where tm.cod_metodo = tfm.cod_metodo ');
      Q.SQL.Add('   and tfm.cod_funcao = tf.cod_funcao ');
      Q.SQL.Add('   and tf.cod_funcao = tpf.cod_funcao ');
      Q.SQL.Add('   and tm.dta_fim_validade is null ');
      Q.SQL.Add('   and tfm.dta_fim_validade is null ');
      Q.SQL.Add('   and tf.dta_fim_validade is null ');
      Q.SQL.Add('   and tpf.cod_perfil = :cod_perfil ');
{$ENDIF}
      Q.ParamByName('cod_perfil').AsInteger := CodPerfil;
      Q.Open;

      // Carrega Métodos disponíveis para o usuário
      Conexao.LimpaMetodos;
      While not Q.EOF do begin
        if Conexao.SetMetodo(Q.FieldByName('cod_metodo').AsInteger, True) < 0 then begin
          Mensagens.Adicionar(174, Self.ClassName, 'CarregaMetodos', [Q.FieldByName('cod_metodo').AsInteger]);
          Result := -174;
          Exit;
        end;
        Q.Next;
      end;
      Result := 0;
      Q.Close;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(176, Self.ClassName, 'CarregaMetodos', [E.Message]);
        Result := -176;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntAcesso.TrataErroLogin(CodUsuario: Integer): Integer;
var
  Q : THerdomQuery;
  MaxQtd, Qtd, QtdAcum: Integer;
  Dta : TDateTime;
begin
  Result := -1;
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Abre Transação
      beginTran;

      // Atualiza dados do usuário
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_usuario ');
      Q.SQL.Add('   set qtd_acum_logins_incorretos = isnull(qtd_acum_logins_incorretos, 0) + 1, ');
      Q.SQL.Add('       dta_ultimo_login_incorreto = getdate(), ');
      Q.SQL.Add('       qtd_logins_incorretos = isnull(qtd_logins_incorretos, 0) + 1 ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.ExecSQL;

      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select qtd_acum_logins_incorretos,  ');
      Q.SQL.Add('       dta_ultimo_login_incorreto, ');
      Q.SQL.Add('       qtd_logins_incorretos ');
      Q.SQL.Add('  from tab_usuario ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.Open;

      QtdAcum := Q.FieldByName('qtd_acum_logins_incorretos').AsInteger;
      Dta     := Q.FieldByName('dta_ultimo_login_incorreto').AsDateTime;
      Qtd     := Q.FieldByName('qtd_logins_incorretos').AsInteger;
      MaxQtd  := StrToInt(ValorParametro(1));

      if Qtd < MaxQtd then begin
        Mensagens.Adicionar(160, Self.ClassName, 'Inicializar', [IntToStr(MaxQtd - Qtd)]);
        Result := -160;
      end;

      // Bloqueia usuáro se atingiu o número máximo de logins incorretos permitidos
      if Qtd = MaxQtd then begin
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_usuario ');
        Q.SQL.Add('   set ind_usuario_bloqueado = ''S'' ');
        Q.SQL.Add(' where cod_usuario = :cod_usuario ');
{$ENDIF}
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
        Q.ExecSQL;

        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_bloqueio_usuario ');
        Q.SQL.Add(' (cod_usuario, ');
        Q.SQL.Add('  dta_inicio_bloqueio, ');
        Q.SQL.Add('  dta_fim_bloqueio, ');
        Q.SQL.Add('  cod_motivo_bloqueio, ');
        Q.SQL.Add('  txt_observacao_bloqueio, ');
        Q.SQL.Add('  txt_observacao_usuario, ');
        Q.SQL.Add('  txt_procedimento_usuario, ');
        Q.SQL.Add('  dta_insercao_registro, ');
        Q.SQL.Add('  cod_usuario_insercao) ');
        Q.SQL.Add('select :cod_usuario, ');
        Q.SQL.Add('       getdate(), ');
        Q.SQL.Add('       null, ');
        Q.SQL.Add('       tmb.cod_motivo_bloqueio, ');
        Q.SQL.Add('       null, ');
        Q.SQL.Add('       tmb.txt_observacao_usuario, ');
        Q.SQL.Add('       tmb.txt_procedimento_usuario, ');
        Q.SQL.Add('       getdate(), ');
        Q.SQL.Add('       convert(integer, tps.val_parametro_sistema) ');
        Q.SQL.Add('  from tab_motivo_bloqueio tmb, ');
        Q.SQL.Add('       tab_parametro_sistema tps ');
        Q.SQL.Add(' where tmb.cod_motivo_bloqueio = 1 ');
        Q.SQL.Add('   and tps.cod_parametro_sistema = 3 ');
{$ENDIF}
        Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
        Q.ExecSQL;

        Result := AtualizaBloqueio(CodUsuario);
        if Result < 0 then begin
          Rollback;
          Exit;
        end;
        Mensagens.Adicionar(161, Self.ClassName, 'TrataErroLogin', []);
        Result := -161;
      end;
      Commit;
      FIntUsuario.QtdAcumLoginsIncorretos := QtdAcum;
      FIntUsuario.DtaUltimoLoginIncorreto := Dta;
      FIntUsuario.QtdLoginsIncorretos     := Qtd;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(177, Self.ClassName, 'TrataErroLogin', [E.Message]);
        Result := -177;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntAcesso.TrataLoginCorreto(CodUsuario: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Abre Transação
      beginTran;

      // Atualiza dados do usuário
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_usuario ');
      Q.SQL.Add('   set qtd_acum_logins_corretos = isnull(qtd_acum_logins_corretos, 0) + 1, ');
      Q.SQL.Add('       dta_ultimo_login_correto = getdate(), ');
      Q.SQL.Add('       qtd_logins_incorretos = 0 ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.ExecSQL;

      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select qtd_acum_logins_corretos,  ');
      Q.SQL.Add('       dta_ultimo_login_correto ');
      Q.SQL.Add('  from tab_usuario ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.Open;

      FIntUsuario.QtdAcumLoginsCorretos   := Q.FieldByName('qtd_acum_logins_corretos').AsInteger;
      FIntUsuario.DtaUltimoLoginCorreto   := Q.FieldByName('dta_ultimo_login_correto').AsDateTime;

      // Verifica se há comunicados expirados. Se houver, armazena no histórico
      // com status "Não lido" e exclui os mesmos da tab_comunicado_usuario
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_historico_comunicado ');
      Q.SQL.Add('select cod_comunicado, ');
      Q.SQL.Add('       cod_usuario_destinatario, ');
      Q.SQL.Add('       :dta_sistema, ');
      Q.SQL.Add('       ''N'' ');
      Q.SQL.Add('  from tab_comunicado_usuario ');
      Q.SQL.Add(' where cod_usuario_destinatario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade < :dta_sistema ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.ParamByName('dta_sistema').AsDateTime := FIntUsuario.DtaUltimoLoginCorreto;
      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_comunicado_usuario ');
      Q.SQL.Add(' where cod_usuario_destinatario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade < :dta_sistema ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := CodUsuario;
      Q.ParamByName('dta_sistema').AsDateTime := FIntUsuario.DtaUltimoLoginCorreto;
      Q.ExecSQL;

      // Encerra transação
      Commit;
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(178, Self.ClassName, 'TrataLoginCorreto', [E.Message]);
        Result := -178;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntAcesso.QtdComunicadosNaoLidos: Integer;
var
  Q : THerdomQuery;
  DtaSistema : TDatetime;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('QtdComunicadosNaoLidos');
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Abre Transação
      beginTran;

      // Obtem data do sistema
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select getdate() as dta_sistema ');
{$ENDIF}
      Q.Open;
      DtaSistema := Q.FieldByName('dta_sistema').AsDateTime;

      // Verifica se há comunicados expirados. Se houver, armazena no histórico
      // com status "Não lido" e exclui os mesmos da tab_comunicado_usuario
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_historico_comunicado ');
      Q.SQL.Add('select cod_comunicado, ');
      Q.SQL.Add('       cod_usuario_destinatario, ');
      Q.SQL.Add('       :dta_sistema, ');
      Q.SQL.Add('       ''N'' ');
      Q.SQL.Add('  from tab_comunicado_usuario ');
      Q.SQL.Add(' where cod_usuario_destinatario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade < :dta_sistema ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger  := FIntUsuario.CodUsuario;
      Q.ParamByName('dta_sistema').AsDateTime := DtaSistema;
      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_comunicado_usuario ');
      Q.SQL.Add(' where cod_usuario_destinatario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade < :dta_sistema ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger  := FIntUsuario.CodUsuario;
      Q.ParamByName('dta_sistema').AsDateTime := DtaSistema;
      Q.ExecSQL;

      // Encerra transação
      Commit;

      // Verifica se há comunicados não lidos
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(count(*), 0) as qtd_comunicados_nao_lidos ');
      Q.SQL.Add('  from tab_comunicado_usuario ');
      Q.SQL.Add(' where cod_usuario_destinatario = :cod_usuario ');
      Q.SQL.Add('   and :dta_sistema between dta_inicio_validade and dta_fim_validade');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger  := FIntUsuario.CodUsuario;
      Q.ParamByName('dta_sistema').AsDateTime := DtaSistema;
      Q.Open;

      if Q.IsEmpty then begin
        Result := 0;
      end else begin
        Result := Q.FieldByName('qtd_comunicados_nao_lidos').AsInteger;
      end;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(278, Self.ClassName, 'QtdComunicadosNaoLidos', [E.Message]);
        Result := -278;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;
{
function TIntAcesso.VerificaLetraNumero(Str: String): Integer;
var
  ExisteLetra, ExisteNumero : Boolean;
  X : Integer;
begin
  Str := UpperCase(Str);
  ExisteLetra := False;
  ExisteNumero := False;

  X := 1;

  While (X <= Length(Str)) and (not ExisteLetra) and (not ExisteNumero) do begin
    if (Ord(Str[X]) >= 65) or (Ord(Str[X]) <= 90) then begin
      ExisteLetra := True;
    end;
    if (Ord(Str[X]) >= 48) or (Ord(Str[X]) <= 57) then begin
      ExisteNumero := True;
    end;
    Inc(X);
  end;

  if (not ExisteLetra) or (not ExisteNumero) then begin
    Mensagens.Adicionar(1068, Self.ClassName, 'VerificaLetraNumero', []);
    Result := -1068;
    Exit;
  end;

  Result := 0;
end;
}

function TIntAcesso.AlterarUsuario(TxtSenhaAtual, NomUsuarioNovo,
  TxtSenhaNova, NomTratamentoNovo: String): Integer;
var
  Q : THerdomQuery;
  CodRegistroLog : Integer;
  TxtSenhaUsuario : String;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('AlterarUsuario');
    Exit;
  end;

  // Verifica se há usuário logado no sistema
  if Conexao.CodUsuario = -1 then begin
    Mensagens.Adicionar(373, Self.ClassName, 'AlterarUsuario', []);
    Result := -373;
    Exit;
  end;

  // Verifica se pelo menos um parâmetro foi informado
  if (TxtSenhaAtual = '') and
     (NomUsuarioNovo = '') and
     (TxtSenhaNova = '' ) and
     (NomTratamentoNovo = '') then begin
    Mensagens.Adicionar(215, Self.ClassName, 'AlterarUsuario', []);
    Result := -215;
    Exit;
  end;

  // Verifica se tamanho do nome e senha estão corretos
  if NomUsuarioNovo <> '' then begin
    Result := TrataString(NomUsuarioNovo, 15, 'Nome do usuário');
    if Result < 0 then begin
      Exit;
    end;
    if Length(NomUsuarioNovo) < 3  then begin
      Mensagens.Adicionar(210, Self.ClassName, 'AlterarUsuario', []);
      Result := -210;
      Exit;
    end;
  end;

  if TxtSenhaNova <> '' then begin
    Result := TrataString(NomUsuarioNovo, 15, 'Senha');
    if Result < 0 then begin
      Exit;
    end;
    if Length(TxtSenhaNova) < 6  then begin
      Mensagens.Adicionar(210, Self.ClassName, 'AlterarUsuario', []);
      Result := -210;
      Exit;
    end;
  end;

  //----------------------------------------------------
  //Verifica se a variável não contem espaços em brancos
  //----------------------------------------------------
  if Pos(' ', NomUsuarioNovo) > 0 then begin
    Mensagens.Adicionar(293, Self.ClassName, 'AlterarUsuario', []);
    Result := -293;
    Exit;
  end;

  if (NomUsuarioNovo <> '') and (TxtSenhaNova <> '') then begin
    if Uppercase(TxtSenhaNova) = UpperCase(NomUsuarioNovo) then begin
      Mensagens.Adicionar(1090, Self.ClassName, 'AlterarUsuario', []);
      Result := -1090;
      Exit;
    end;
  end;

//  // Verifica se senha possui letras e números
//  Result := VerificaLetraNumero(TxtSenhaNova);
//  if Result < 0 then Exit;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Obtem senha do usuário logado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select txt_senha from tab_usuario ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade is null    ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(208, Self.ClassName, 'AlterarUsuario', []);
        Result := -208;
        Exit;
      end;
      TxtSenhaUsuario := Descriptografar(Q.FieldByName('txt_senha').AsString);
      Q.Close;

      // Verifica se a senha atual é válida
      if (NomUsuarioNovo <> '') or (TxtSenhaNova <> '') then begin
        if TxtSenhaAtual = '' then begin
          Mensagens.Adicionar(374, Self.ClassName, 'AlterarUsuario', []);
          Result := -374;
          Exit;
        end;
        if UpperCase(TxtSenhaAtual) <> UpperCase(TxtSenhaUsuario) then begin
          Mensagens.Adicionar(375, Self.ClassName, 'AlterarUsuario', []);
          Result := -375;
          Exit;
        end;
      end;

      // Verifica existencia de registro duplicado
      if NomUsuarioNovo <> '' then begin
        Q.SQL.Clear;
  {$IFDEF MSSQL}
        Q.SQL.Add('select 1 from tab_usuario ');
        Q.SQL.Add(' where nom_usuario  = :nom_usuario ');
        Q.SQL.Add('   and cod_usuario != :cod_usuario ');
        Q.SQL.Add('   and dta_fim_validade is null    ');
  {$ENDIF}
        Q.ParamByName('nom_usuario').AsString  := NomUsuarioNovo;
        Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
        Q.Open;
        if not Q.IsEmpty then begin
          Mensagens.Adicionar(205, Self.ClassName, 'AlterarUsuario', [NomUsuarioNovo]);
          Result := -205;
          Exit;
        end;
        Q.Close;
      end;  

      // Verifica existencia do registro e pega cod_registro_log do mesmo
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select nom_usuario, txt_senha, cod_registro_log from tab_usuario ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(209, Self.ClassName, 'AlterarUsuario', [IntToStr(Conexao.CodUsuario)]);
        Result := -209;
        Exit;
      end else begin
        // Pega CodRegistroLog
        CodRegistroLog := Q.FieldByName('cod_registro_log').AsInteger;
      end;

      // Verifica se nome informado não é idêntico à senha já gravada
      if (NomUsuarioNovo <> '') and (TxtSenhaNova = '') then begin
        if UpperCase(NomUsuarioNovo) = Uppercase(Descriptografar(Q.FieldByName('txt_senha').AsString)) then begin
          Mensagens.Adicionar(1090, Self.ClassName, 'Alterar', []);
          Result := -1090;
          Exit;
        end;
      end;

      // Verifica se senha informada não é idêntica ao nome já gravado
      if (TxtSenhaNova <> '') and (NomUsuarioNovo = '') then begin
        if UpperCase(TxtSenhaNova) = Uppercase(Q.FieldByName('nom_usuario').AsString) then begin
          Mensagens.Adicionar(1090, Self.ClassName, 'Alterar', []);
          Result := -1090;
          Exit;
        end;
      end;

      Q.Close;

      // Abre transação
      beginTran;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_usuario', CodRegistroLog, 2, 117);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_usuario ');
      Q.SQL.Add('   set ');
      if NomUsuarioNovo <> '' then begin
        Q.SQL.Add('   nom_usuario = :nom_usuario,');
      end;
      if TxtSenhaNova <> '' then begin
        Q.SQL.Add('   txt_senha = :txt_senha,');
      end;
      if NomTratamentoNovo <> '' then begin
        Q.SQL.Add('   nom_tratamento = :nom_tratamento,');
      end;

      // Pra tirar a merda de vírgula que fica na última linha antes do where
      Q.SQL[Q.SQL.Count-1] := Copy(Q.SQL[Q.SQL.Count-1], 1, Length(Q.SQL[Q.SQL.Count-1]) - 1);

      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
{$ENDIF}
      if NomUsuarioNovo <> '' then begin
        Q.ParamByName('nom_usuario').AsString      := NomUsuarioNovo;
      end;
      if TxtSenhaNova <> '' then begin
        Q.ParamByName('txt_senha').AsString      := Criptografar(TxtSenhaNova);
      end;
      if NomTratamentoNovo <> '' then begin
        Q.ParamByName('nom_tratamento').AsString      := NomTratamentoNovo;
      end;
      Q.ParamByName('cod_usuario').AsInteger      := Conexao.CodUsuario;
      Q.ExecSQL;

      // Grava Log de Operação (NomTabela, CodRegistroLog, CodOperacao, CodMetodo)
      // CodOperacao: 1-Insert, 2-Alteração Antes, 3-Alteração Após, 4-Exclusão, 5-Finalização Validade
      Result := GravarLogOperacao('tab_usuario', CodRegistroLog, 3, 117);
      if Result < 0 then begin
        Rollback;
        Exit;
      end;

      // Cofirma transação
      Commit;

      // Atualiza dados da propriedade usuario
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select nom_usuario, ');
      Q.SQL.Add('       nom_tratamento ');
      Q.SQL.Add('  from tab_usuario ');
      Q.SQL.Add(' where cod_usuario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger      := Conexao.CodUsuario;
      Q.Open;

      FIntUsuario.NomUsuario               := Q.FieldByName('nom_usuario').AsString;
      FIntUsuario.NomTratamento            := Q.FieldByName('nom_tratamento').AsString;

      // Retorna status "ok" do método
      Result := 0;
    except
      on E: exception do begin
        Rollback;
        Mensagens.Adicionar(216, Self.ClassName, 'AlterarUsuario', [E.Message]);
        Result := -216;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

function TIntAcesso.DefinirFazendaTrabalho(CodFazenda: Integer): Integer;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('DefinirFazendaTrabalho');
    Exit;
  end;

  try
    Result := Conexao.DefinirFazendaTrabalho(CodFazenda);
    case Result of
      307: {Produtor de trabalho não definido}
        begin
          Mensagens.Adicionar(307, Self.ClassName, 'DefinirFazendaTrabalho', []);
          Result := -307;
          Exit;
        end;
      310: {Inexistência da fazenda}
        begin
          Mensagens.Adicionar(310, Self.ClassName, 'DefinirFazendaTrabalho', [IntToStr(CodFazenda)]);
          Result := -310;
          Exit;
        end;
      0: {Procedimento bem sucedido}
        Result := 0;
    else
      Exit;
    end;

  except
    on E: exception do begin
      Rollback;
      Mensagens.Adicionar(443, Self.ClassName, 'DefinirFazendaTrabalho', [E.Message]);
      Result := -443;
      Exit;
    end;
  end;
end;

function TIntAcesso.ExisteFazendaTrabalho: Boolean;
begin
  Result := False;
  if not Inicializado then begin
    RaiseNaoInicializado('ExisteFazendaTrabalho');
    Exit;
  end;
  Result := Conexao.ExisteFazendaTrabalho;
end;

procedure TIntAcesso.LimparFazendaTrabalho;
begin
  if not Inicializado then begin
    RaiseNaoInicializado('LimparFazendaTrabalho');
    Exit;
  end;
  Conexao.LimpaFazendaTrabalho;
end;

function TIntAcesso.QtdComunicadosImportantesNaoLidos: Integer;
var
  Q : THerdomQuery;
  DtaSistema : TDatetime;
begin
  Result := -1;
  if not Inicializado then begin
    RaiseNaoInicializado('QtdComunicadosImportantesNaoLidos');
    Exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  try
    try
      // Abre Transação
      beginTran;

      // Obtem data do sistema
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select getdate() as dta_sistema ');
{$ENDIF}
      Q.Open;
      DtaSistema := Q.FieldByName('dta_sistema').AsDateTime;

      // Verifica se há comunicados expirados. Se houver, armazena no histórico
      // com status "Não lido" e exclui os mesmos da tab_comunicado_usuario
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_historico_comunicado ');
      Q.SQL.Add('select cod_comunicado, ');
      Q.SQL.Add('       cod_usuario_destinatario, ');
      Q.SQL.Add('       :dta_sistema, ');
      Q.SQL.Add('       ''N'' ');
      Q.SQL.Add('  from tab_comunicado_usuario ');
      Q.SQL.Add(' where cod_usuario_destinatario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade < :dta_sistema ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger  := FIntUsuario.CodUsuario;
      Q.ParamByName('dta_sistema').AsDateTime := DtaSistema;
      Q.ExecSQL;

      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_comunicado_usuario ');
      Q.SQL.Add(' where cod_usuario_destinatario = :cod_usuario ');
      Q.SQL.Add('   and dta_fim_validade < :dta_sistema ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger  := FIntUsuario.CodUsuario;
      Q.ParamByName('dta_sistema').AsDateTime := DtaSistema;
      Q.ExecSQL;

      // Encerra transação
      Commit;

      // Verifica se há comunicados importantes não lidos
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(count(*), 0) as qtd_comunicados_nao_lidos ');
      Q.SQL.Add('  from tab_comunicado_usuario tcu, ');
      Q.SQL.Add('       tab_comunicado tc ');
      Q.SQL.Add(' where tcu.cod_usuario_destinatario = :cod_usuario ');
      Q.SQL.Add('   and tc.cod_comunicado = tcu.cod_comunicado ');
      Q.SQL.Add('   and tc.ind_comunicado_importante = ''S'' ');
      Q.SQL.Add('   and :dta_sistema between tcu.dta_inicio_validade and tcu.dta_fim_validade ');
{$ENDIF}
      Q.ParamByName('cod_usuario').AsInteger  := FIntUsuario.CodUsuario;
      Q.ParamByName('dta_sistema').AsDateTime := DtaSistema;
      Q.Open;

      if Q.IsEmpty then begin
        Result := 0;
      end else begin
        Result := Q.FieldByName('qtd_comunicados_nao_lidos').AsInteger;
      end;
    except
      on E:exception do begin
        Rollback;
        Mensagens.Adicionar(444, Self.ClassName, 'QtdComunicadosImportantesNaoLidos', [E.Message]);
        Result := -444;
        Exit;
      end;
    end;
  Finally
    Q.Free;
  end;
end;

procedure TIntAcesso.LimpaDadosAcesso;
begin
  // Limpa dados armazenados no objeto conexão
  Conexao.LimpaFuncoes;
  Conexao.LimpaMetodos;
  Conexao.CodUsuario := -1;
  Conexao.CodProdutor := -1;
  Conexao.CodProdutorTrabalho := -1;
  Conexao.CodFazendaTrabalho := -1;
  Conexao.CodPapelUsuario := -1;
  Conexao.ItensMenuDisponiveis.Clear;
  Conexao.ItensMenuPesquisa.Clear;
  Conexao.PonteiroPesquisa := 0;
  Conexao.LimpaProdutorTrabalho;
  Conexao.LimpaFazendaTrabalho;
  FTipoAcesso := '';
end;

end.

