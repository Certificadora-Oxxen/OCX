// ********************************************************************
// *  Projeto : BoiTata
// *  Sistema : Banners
// *  Desenvolvedor : Hitalo Cordeiro Silva
// *  Versão  : 1
// *  Data : 16/07/2002
// *  Descrição Resumida : Cadastro de Banners
// *
// ********************************************************************
// *  Últimas Alterações
// *  Analista      Data     Descrição Alteração
// *   Hitalo    16/07/2002  Adicionar Data Fim na Propriedade e no
// *                         metodo pesquisar
// *   Hitalo    17/07/2002  Adicionar TrataString nos Métodos Inserir
// *                         ,Alterar e Pesquisar
// *
// *
// *
// ********************************************************************

unit uIntBanners;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntBanner, dbtables, sysutils, db;

type
  { TIntBanners }
  TIntBanners = class(TIntClasseBDNavegacaoBasica)
  private
    FIntBanner : TIntBanner;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Pesquisar(NomArquivo: String; CodTipoBanner: Integer;
      IndPesquisarDesativados: Boolean; IndEscopoPesquisa, CodAnunciante: Integer): Integer;
    function Inserir(NomArquivo: String; CodTipoBanner: Integer; UrlDestino,
      TxtAlternativo: String; CodTipoTarget, CodAnunciante: Integer): Integer;
    function Alterar(CodBanner: Integer; UrlDestino,
      TxtAlternativo: String): Integer;
    function Liberar(CodBanner, CodTipoTarget: Integer): Integer;
    function Excluir(CodBanner: Integer): Integer;
    function Buscar(CodBanner: Integer): Integer;
    function ExisteNomeArquivo(NomArquivo: String): Integer;
    property IntBanner : TIntBanner read FIntBanner write FIntBanner;
  end;

implementation

{ TIntBanners }
constructor TIntBanners.Create;
begin
  inherited;
  FIntBanner := TIntBanner.Create;
end;

destructor TIntBanners.Destroy;
begin
  FIntBanner.Free;
  inherited;
end;

function TIntBanners.Pesquisar(NomArquivo: String; CodTipoBanner: Integer;
  IndPesquisarDesativados: Boolean; IndEscopoPesquisa, CodAnunciante: Integer): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(1) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select tb.cod_banner as CodBanner, ');
  Query.SQL.Add('       tb.nom_arquivo as NomArquivo, ');
  Query.SQL.Add('       tb.cod_tipo_banner as CodTipoBanner, ');
  Query.SQL.Add('       ttb.des_tipo_banner as DesTipoBanner, ');
  Query.SQL.Add('       tb.dta_fim_validade as DtaFimValidade, ');
  Query.SQL.Add('       tb.url_destino as URLDestino, ');
  Query.SQL.Add('       ta.nom_anunciante as NomAnunciante, ');
  Query.SQL.Add('       case ');
  Query.SQL.Add('         when tb.dta_liberacao is null then ''Não Liberado''');
  Query.SQL.Add('       else ');
  Query.SQL.Add('         ''Liberado''');
  Query.SQL.Add('       end as DesSituacao ');
  Query.SQL.Add('  from tab_banner tb, ');
  Query.SQL.Add('       tab_tipo_banner ttb, ');
  Query.SQL.Add('       tab_anunciante ta ');
  Query.SQL.Add(' where ttb.cod_tipo_banner = tb.cod_tipo_banner ');
  Query.SQL.Add('   and ta.cod_anunciante = tb.cod_anunciante ');
  Query.SQL.Add('   and ((tb.dta_fim_validade is null) or (:ind_pesquisar_desativados = 1)) ');
  If NomArquivo <> '' Then Begin
    Query.SQL.Add('   and tb.nom_arquivo like :nom_arquivo ');
  End;
  Query.SQL.Add('   and ((tb.cod_tipo_banner = :cod_tipo_banner) or (:cod_tipo_banner = -1)) ');
  Query.SQL.Add('   and ((tb.cod_anunciante = :cod_anunciante) or (:cod_anunciante = -1)) ');
  If IndEscopoPesquisa = 1 Then Begin
    Query.SQL.Add('   and tb.dta_liberacao is not null ');
  End Else If IndEscopoPesquisa = 2 Then Begin
    Query.SQL.Add('   and tb.dta_liberacao is null ');
  End;
  Query.SQL.Add(' order by ta.nom_anunciante, ');
  Query.SQL.Add('          tb.nom_arquivo ');
{$ENDIF}
  If NomArquivo <> '' Then Begin
    Query.ParamByName('nom_arquivo').AsString      := '%' + NomArquivo + '%';
  End;
  Query.ParamByName('cod_tipo_banner').AsInteger := CodTipoBanner;
  Query.ParamByName('cod_anunciante').AsInteger := CodAnunciante;
  If IndPesquisarDesativados Then Begin
    Query.ParamByName('ind_pesquisar_desativados').AsInteger := 1;
  End Else Begin
    Query.ParamByName('ind_pesquisar_desativados').AsInteger := 0;
  End;

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(100, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -100;
      Exit;
    End;
  End;
end;

function TIntBanners.Inserir(NomArquivo: String; CodTipoBanner: Integer; UrlDestino,
  TxtAlternativo: String; CodTipoTarget, CodAnunciante: Integer): Integer;
var
  Q : THerdomQuery;
  CodBanner : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(2) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  //Verifica parametro NomArquivo
  If NomArquivo = '' Then Begin
    Mensagens.Adicionar(232, Self.ClassName, 'Inserir', []);
    Result := -232;
    Exit;
  End;

  //Verifica parametro URLDestino
  If URLDestino = '' Then Begin
    Mensagens.Adicionar(233, Self.ClassName, 'Inserir', []);
    Result := -233;
    Exit;
  End;

  //*********************************
  //Nome do Arquivo
  //*********************************
  //---------------------------------
  //Trata a variavel Nome do Arquivo
  //---------------------------------
  result := TrataString(NomArquivo,30,'Nome do Arquivo');

  if result < 0 then
    exit;

  //----------------------------------------------------
  //Verifica se a variável não contem espaços em brancos
  //----------------------------------------------------
  if Pos(' ', NomArquivo) > 0 then begin
    Mensagens.Adicionar(292, Self.ClassName, 'Inserir', []);
    result := -292;
    exit;
  end;

  //----------------------------
  //Trata a variavel URL Destino
  //----------------------------
  result := TrataString(URLDestino,255,'URL Destino do Banner');

  if result < 0 then
    exit;

  //---------------------------------
  //Trata a variavel Txt Alternativo
  //---------------------------------
  If trim(TxtAlternativo) <> '' Then Begin
    result := TrataString(TxtAlternativo,255,'Txt Alternativo do Banner');

    if result < 0 then
      exit;
  end;
  
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_banner ');
      Q.SQL.Add(' where nom_arquivo = :nom_arquivo ');
{$ENDIF}
      Q.ParamByName('nom_arquivo').AsString := NomArquivo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(105, Self.ClassName, 'Inserir', [NomArquivo]);
        Result := -105;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro Tipo de Banner
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_banner ');
      Q.SQL.Add(' where cod_tipo_banner = :cod_tipo_banner ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_banner').AsInteger := CodTipoBanner;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(234, Self.ClassName, 'Inserir', [IntToStr(CodTipoBanner)]);
        Result := -234;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro Tipo Target
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_target ');
      Q.SQL.Add(' where cod_tipo_target = :cod_tipo_target ');
{$ENDIF}
      Q.ParamByName('cod_tipo_target').AsInteger := CodTipoTarget;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(235, Self.ClassName, 'Inserir', [IntToStr(CodTipoTarget)]);
        Result := -235;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro Anunciante
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_anunciante ');
      Q.SQL.Add(' where cod_anunciante = :cod_anunciante ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_anunciante').AsInteger := CodAnunciante;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(141, Self.ClassName, 'Inserir', [IntToStr(CodAnunciante)]);
        Result := -141;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_banner), 0) + 1 as cod_banner from tab_banner');
{$ENDIF}
      Q.Open;
      CodBanner := Q.FieldByName('cod_banner').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_banner ');
      Q.SQL.Add(' (cod_banner, ');
      Q.SQL.Add('  nom_arquivo, ');
      Q.SQL.Add('  cod_tipo_banner, ');
      Q.SQL.Add('  url_destino, ');
      Q.SQL.Add('  txt_alternativo, ');
      Q.SQL.Add('  cod_tipo_target, ');
      Q.SQL.Add('  cod_anunciante, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_banner, ');
      Q.SQL.Add('  :nom_arquivo, ');
      Q.SQL.Add('  :cod_tipo_banner, ');
      Q.SQL.Add('  :url_destino, ');
      Q.SQL.Add('  :txt_alternativo, ');
      Q.SQL.Add('  :cod_tipo_target, ');
      Q.SQL.Add('  :cod_anunciante, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger      := CodBanner;
      Q.ParamByName('nom_arquivo').AsString      := NomArquivo;
      Q.ParamByName('cod_tipo_banner').AsInteger := CodTipoBanner;
      Q.ParamByName('url_destino').AsString      := URLDestino;
      If TxtAlternativo = '' Then Begin
        Q.ParamByName('txt_alternativo').DataType := ftString;
        Q.ParamByName('txt_alternativo').Clear;
      End Else Begin
        Q.ParamByName('txt_alternativo').AsString := TxtAlternativo;
      End;
      Q.ParamByName('cod_tipo_target').AsInteger := CodTipoTarget;
      Q.ParamByName('cod_anunciante').AsInteger  := CodAnunciante;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do banner criado
      Result := CodBanner;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(101, Self.ClassName, 'Inserir', [E.Message]);
        Result := -101;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntBanners.Alterar(CodBanner: Integer; UrlDestino,
  TxtAlternativo: String): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(3) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  //---------------------------------
  //Trata a variavel Txt Alternativo
  //---------------------------------
  If trim(TxtAlternativo) <> '' Then Begin
    result := TrataString(TxtAlternativo,255,'Txt Alternativo do Banner');

    if result < 0 then
      exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_banner ');
      Q.SQL.Add(' where cod_banner = :cod_banner ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(108, Self.ClassName, 'Alterar', [IntToStr(CodBanner)]);
        Result := -108;
        Exit;
      End;
      Q.Close;

      If UrlDestino = '' Then Begin
        Mensagens.Adicionar(233, Self.ClassName, 'Alterar', []);
        Result := -233;
        Exit;
      End;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_banner ');
      Q.SQL.Add('   set url_destino = :url_destino, ');
      Q.SQL.Add('       txt_alternativo = :txt_alternativo ');
      Q.SQL.Add(' where cod_banner = :cod_banner ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger      := CodBanner;
      Q.ParamByName('url_destino').AsString      := URLDestino;
      If TxtAlternativo = '' Then Begin
        Q.ParamByName('txt_alternativo').DataType := ftString;
        Q.ParamByName('txt_alternativo').Clear;
      End Else Begin
        Q.ParamByName('txt_alternativo').AsString  := TxtAlternativo;
      End;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(102, Self.ClassName, 'Alterar', [E.Message]);
        Result := -102;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntBanners.Liberar(CodBanner, CodTipoTarget: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Liberar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(6) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_banner ');
      Q.SQL.Add(' where cod_banner = :cod_banner ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(108, Self.ClassName, 'Liberar', [IntToStr(CodBanner)]);
        Result := -108;
        Exit;
      End;
      Q.Close;

      // Verifica se banner já foi liberado
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_banner ');
      Q.SQL.Add(' where cod_banner = :cod_banner ');
      Q.SQL.Add('   and dta_liberacao is not null ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(110, Self.ClassName, 'Liberar', [IntToStr(CodBanner)]);
        Result := -110;
        Exit;
      End;
      Q.Close;

      // Verifica existencia do registro Tipo Target
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_target ');
      Q.SQL.Add(' where cod_tipo_target = :cod_tipo_target ');
{$ENDIF}
      Q.ParamByName('cod_tipo_target').AsInteger := CodTipoTarget;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(235, Self.ClassName, 'Inserir', [IntToStr(CodTipoTarget)]);
        Result := -235;
        Exit;
      End;
      Q.Close;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_banner ');
      Q.SQL.Add('   set cod_tipo_target = :cod_tipo_target, ');
      Q.SQL.Add('       dta_liberacao = getdate() ');
      Q.SQL.Add(' where cod_banner = :cod_banner ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger      := CodBanner;
      Q.ParamByName('cod_tipo_target').AsInteger := CodTipoTarget;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(109, Self.ClassName, 'Liberar', [E.Message]);
        Result := -109;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntBanners.Excluir(CodBanner: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(5) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_banner ');
      Q.SQL.Add(' where cod_banner = :cod_banner ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(108, Self.ClassName, 'Excluir', [IntToStr(CodBanner)]);
        Result := -108;
        Exit;
      End;
      Q.Close;

      // Consiste se há programação para o anúncio
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_programa_anuncio ');
      Q.SQL.Add(' where cod_banner = :cod_banner ');
      Q.SQL.Add('   and dta_fim_anuncio >= getdate() ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(106, Self.ClassName, 'Excluir', [IntToStr(CodBanner)]);
        Result := -106;
        Exit;
      End;
      Q.Close;

      // Consiste se é um banner default de algum grupo de página
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_banner_default ');
      Q.SQL.Add(' where cod_banner = :cod_banner ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(107, Self.ClassName, 'Excluir', [IntToStr(CodBanner)]);
        Result := -107;
        Exit;
      End;
      Q.Close;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_banner ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_banner = :cod_banner ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger      := CodBanner;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(103, Self.ClassName, 'Excluir', [E.Message]);
        Result := -103;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntBanners.Buscar(CodBanner: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(4) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select tb.cod_banner, ');
      Q.SQL.Add('       tb.nom_arquivo, ');
      Q.SQL.Add('       tb.cod_tipo_banner, ');
      Q.SQL.Add('       tb.url_destino, ');
      Q.SQL.Add('       tb.txt_alternativo, ');
      Q.SQL.Add('       tb.cod_anunciante, ');
      Q.SQL.Add('       tb.cod_tipo_target, ');
      Q.SQL.Add('       ttb.des_tipo_banner, ');
      Q.SQL.Add('       ta.nom_anunciante, ');
      Q.SQL.Add('       ttt.des_tipo_target, ');
      Q.SQL.Add('       tb.dta_fim_validade, ');
      Q.SQL.Add('       ttt.txt_comando_target ');
      Q.SQL.Add('  from tab_banner tb, ');
      Q.SQL.Add('       tab_tipo_banner ttb, ');
      Q.SQL.Add('       tab_anunciante ta, ');
      Q.SQL.Add('       tab_tipo_target ttt');
      Q.SQL.Add(' where ttt.cod_tipo_target = tb.cod_tipo_target ');
      Q.SQL.Add('   and ttb.cod_tipo_banner = tb.cod_tipo_banner ');
      Q.SQL.Add('   and ta.cod_anunciante = tb.cod_anunciante ');
      Q.SQL.Add('   and tb.cod_banner = :cod_banner ');
{$ENDIF}
      Q.ParamByName('cod_banner').AsInteger := CodBanner;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(108, Self.ClassName, 'Buscar', [IntToStr(CodBanner)]);
        Result := -108;
        Exit;
      End;

      // Obtem informações do registro
      IntBanner.Codigo           := Q.FieldByName('cod_banner').AsInteger;
      IntBanner.NomArquivo       := Q.FieldByName('nom_arquivo').AsString;
      IntBanner.CodTipoBanner    := Q.FieldByName('cod_tipo_banner').AsInteger;
      IntBanner.URLDestino       := Q.FieldByName('url_destino').AsString;
      IntBanner.TxtAlternativo   := Q.FieldByName('txt_alternativo').AsString;
      IntBanner.CodAnunciante    := Q.FieldByName('cod_anunciante').AsInteger;
      IntBanner.CodTipoTarget    := Q.FieldByName('cod_tipo_target').AsInteger;
      IntBanner.DesTipoBanner    := Q.FieldByName('des_tipo_banner').AsString;
      IntBanner.NomAnunciante    := Q.FieldByName('nom_anunciante').AsString;
      IntBanner.DesTipoTarget    := Q.FieldByName('des_tipo_target').AsString;
      IntBanner.DtaFimValidade   := Q.FieldByName('Dta_Fim_Validade').AsDateTime;
      IntBanner.TxtComandoTarget := Q.FieldByName('txt_comando_target').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(104, Self.ClassName, 'Buscar', [E.Message]);
        Result := -104;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntBanners.ExisteNomeArquivo(NomArquivo: String): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('ExisteNomeArquivo');
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_banner ');
      Q.SQL.Add(' where nom_arquivo = :nom_arquivo ');
{$ENDIF}
      Q.ParamByName('nom_arquivo').AsString := NomArquivo;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Result := 1;
      End Else Begin
        Result := 0;
      End;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(151, Self.ClassName, 'ExisteNomeArquivo', [E.Message]);
        Result := -151;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
End;

end.
