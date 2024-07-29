unit uIntRelatorios;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, dbtables, sysutils, db, uFerramentas, uIntRelatorio,
     Variants;

type

  { TIntRelatorios }

  TIntRelatorios = class(TIntClasseBDNavegacaoBasica)
  private
    FIntRelatorio: TIntRelatorio;
    function ConsistirOrientacao(CodOrientacao: Integer): Integer;
    function ConsistirTamanhoFonte(CodTamanhoFonte: Integer): Integer;
    function ConsistirCampoRelatorio(CodRelatorio, CodCampo: Integer): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Pesquisar(CodRelatorio: Integer): Integer;
    function Buscar(CodRelatorio: Integer): Integer;
    function Personalizar(CodRelatorio, CodOrientacao,
      CodTamanhoFonte: Integer; TxtSubTitulo, CodCampos: String): Integer;
    function CampoAssociado(CodCampo: Integer): Integer;
    property IntRelatorio: TIntRelatorio read FIntRelatorio write FIntRelatorio;
  end;

implementation

{ TIntRelatorios }

constructor TIntRelatorios.Create;
begin
  inherited;
  FIntRelatorio := TIntRelatorio.Create;
end;

destructor TIntRelatorios.Destroy;
begin
  FIntRelatorio.Free;
  inherited;
end;

function TIntRelatorios.ConsistirOrientacao(
  CodOrientacao: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirOrientacao';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.Close;
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_orientacao ' +
                ' where cod_orientacao = :cod_orientacao ');
      Q.ParamByName('cod_orientacao').AsInteger := CodOrientacao;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(928, Self.ClassName, NomeMetodo, []);
        Result := -928;
        Exit;
      end;
      Q.Close;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(929, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -929;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRelatorios.ConsistirTamanhoFonte(
  CodTamanhoFonte: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirTamanhoFonte';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.Close;
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_tamanho_fonte ' +
                ' where cod_tamanho_fonte = :cod_tamanho_fonte ');
      Q.ParamByName('cod_tamanho_fonte').AsInteger := CodTamanhoFonte;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(930, Self.ClassName, NomeMetodo, []);
        Result := -930;
        Exit;
      end;
      Q.Close;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(931, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -931;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRelatorios.ConsistirCampoRelatorio(CodRelatorio,
  CodCampo: Integer): Integer;
const
  NomeMetodo: String = 'ConsistirCampoRelatorio';
var
  Q: THerdomQuery;
begin
  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      Q.Close;
      Q.SQL.Clear;
      Q.SQL.Add('select 1 from tab_campo_relatorio ' +
                ' where cod_relatorio = :cod_relatorio ' +
                '   and cod_campo = :cod_campo ');
      Q.ParamByName('cod_relatorio').AsInteger := CodRelatorio;
      Q.ParamByName('cod_campo').AsInteger := CodCampo;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(932, Self.ClassName, NomeMetodo, []);
        Result := -932;
        Exit;
      end;
      Q.Close;
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(933, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -933;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRelatorios.Buscar(CodRelatorio: Integer): Integer;
const
  Metodo: Integer = 310;
  NomeMetodo: String = 'Buscar';
var
  Q: THerdomQuery;
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

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ' +
                '  tr.cod_relatorio ' +
                '  , tr.txt_titulo ' +
                '  , tr.qtd_colunas ' +
                '  , tr.cod_orientacao ' +
                '  , tr.cod_tamanho_fonte ' +
                '  , tr.ind_personalizavel ' +
                'from ' +
                '  tab_relatorio tr ' +
                'where ' +
                '  cod_relatorio = :cod_relatorio ');
{$ENDIF}
      Q.ParamByName('cod_relatorio').AsInteger := CodRelatorio;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(917, Self.ClassName, NomeMetodo, []);
        Result := -917;
        Exit;
      End;

      // Obtem informações do registro
      IntRelatorio.CodRelatorio := Q.FieldByName('cod_relatorio').AsInteger;
      IntRelatorio.TxtTitulo := Q.FieldByName('txt_titulo').AsString;
      IntRelatorio.QtdColunas := Q.FieldByName('qtd_colunas').AsInteger;
      IntRelatorio.CodOrientacao := Q.FieldByName('cod_orientacao').AsInteger;
      IntRelatorio.CodTamanhoFonte := Q.FieldByName('cod_tamanho_fonte').AsInteger;
      IntRelatorio.IndPersonalizavel := Q.FieldByName('ind_personalizavel').AsString;
      IntRelatorio.TxtSubTitulo := '';

      // Busca os dados personalizados para o relatório, caso eles existam
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ' +
                '  cod_orientacao ' +
                '  , cod_tamanho_fonte ' +
                '  , txt_sub_titulo ' +
                'from ' +
                '  tab_relatorio_usuario ' +
                'where ' +
                '  cod_relatorio = :cod_relatorio ' +
                '  and cod_usuario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_relatorio').AsInteger := CodRelatorio;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.Open;
      if not Q.IsEmpty then begin
        IntRelatorio.CodOrientacao := Q.FieldByName('cod_orientacao').AsInteger;
        IntRelatorio.CodTamanhoFonte := Q.FieldByName('cod_tamanho_fonte').AsInteger;
        IntRelatorio.TxtSubTitulo := Q.FieldByName('txt_sub_titulo').AsString;
      end;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(918, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -918;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRelatorios.Personalizar(CodRelatorio, CodOrientacao,
  CodTamanhoFonte: Integer; TxtSubTitulo, CodCampos: String): Integer;
const
  Metodo: Integer = 311;
  NomeMetodo: String = 'Personalizar';
var
  Q: THerdomQuery;
  X, NumOrdem: Integer;
  sAux, sIndPersonalizavel: String;
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

  Result := TrataString(TxtSubTitulo, 50, 'Subtítulo');
  If Result < 0 Then Exit;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try

      // Consiste se o relatório existe
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select ind_personalizavel, cod_orientacao, cod_tamanho_fonte '+
                ' from tab_relatorio ' +
                ' where cod_relatorio = :cod_relatorio ');
{$ENDIF}
      Q.ParamByName('cod_relatorio').AsInteger := CodRelatorio;
      Q.Open;
      if Q.IsEmpty then begin
        Mensagens.Adicionar(917, Self.ClassName, NomeMetodo, []);
        Result := -917;
        Exit;
      end;
      if Q.FieldByName('ind_personalizavel').AsString = 'N' then begin
        CodOrientacao := Q.FieldByName('cod_orientacao').AsInteger;
        CodTamanhoFonte := Q.FieldByName('cod_tamanho_fonte').AsInteger;
      end;
      sIndPersonalizavel := Q.FieldByName('ind_personalizavel').AsString;
      Q.Close;

      // Verifica se orientação informada é válida
      Result := ConsistirOrientacao(CodOrientacao);
      If Result < 0 Then Exit;

      // Verifica se tamanho da fonte informado é válido
      Result := ConsistirTamanhoFonte(CodTamanhoFonte);
      If Result < 0 Then Exit;

      // Abre transação
      BeginTran;

      // Verifica se já existe um registro de personalização do relatório
      // para o usuário corrente, inserindo ou atualizando os dados
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_relatorio_usuario ' +
                ' where cod_relatorio = :cod_relatorio ' +
                '   and cod_usuario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_relatorio').AsInteger := CodRelatorio;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.Open;
      if Q.IsEmpty then begin
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_relatorio_usuario ' +
                  '  (cod_relatorio ' +
                  '   , cod_usuario ' +
                  '   , cod_orientacao ' +
                  '   , cod_tamanho_fonte ' +
                  '   , txt_sub_titulo) ' +
                  'values ' +
                  '  (:cod_relatorio ' +
                  '   , :cod_usuario ' +
                  '   , :cod_orientacao ' +
                  '   , :cod_tamanho_fonte ' +
                  '   , :txt_sub_titulo) ');
{$ENDIF}
      end else begin
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('update tab_relatorio_usuario set ' +
                  '  cod_orientacao = :cod_orientacao ' +
                  '  , cod_tamanho_fonte = :cod_tamanho_fonte ' +
                  '  , txt_sub_titulo = :txt_sub_titulo ' +
                  'where ' +
                  '  cod_relatorio = :cod_relatorio ' +
                  '  and cod_usuario = :cod_usuario ');
{$ENDIF}
      end;
      Q.ParamByName('cod_relatorio').AsInteger := CodRelatorio;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ParamByName('cod_orientacao').AsInteger := CodOrientacao;
      Q.ParamByName('cod_tamanho_fonte').AsInteger := CodTamanhoFonte;
      Q.ParamByName('txt_sub_titulo').DataType := ftString;
      AtribuiValorParametro(Q.ParamByName('txt_sub_titulo'), TxtSubTitulo);
      Q.ExecSQL;

      // Limpa a lista (caso exista) anterior de campos selecionados pelo
      // usário neste relatório
      Q.Close;
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_campo_relatorio_usuario ' +
                'where ' +
                '  cod_relatorio = :cod_relatorio ' +
                '  and cod_usuario = :cod_usuario ');
{$ENDIF}
      Q.ParamByName('cod_relatorio').AsInteger := CodRelatorio;
      Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
      Q.ExecSQL;

      // Atualiza os campos selecionados pelo usuário para este relatório
      if sIndPersonalizavel = 'S' then begin
        Q.Close;
        Q.SQL.Clear;
{$IFDEF MSSQL}
        Q.SQL.Add('insert into tab_campo_relatorio_usuario ' +
                  '  (cod_relatorio ' +
                  '   , cod_usuario ' +
                  '   , cod_campo ' +
                  '   , num_ordem) ' +
                  'values ' +
                  '   (:cod_relatorio ' +
                  '   , :cod_usuario ' +
                  '   , :cod_campo ' +
                  '   , :num_ordem) ');
{$ENDIF}
        Q.ParamByName('cod_relatorio').AsInteger := CodRelatorio;
        Q.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
        NumOrdem := 1;
        while CodCampos <> '' do begin
          X := Pos(',', CodCampos);
          if X = 0 then begin
            sAux := CodCampos;
            CodCampos := '';
          end else begin
            sAux := Copy(CodCampos, 1, X-1);
            CodCampos := Copy(CodCampos, X+1, Length(CodCampos)-X);
          end;
          // Verifica se o campo é válido para o relatório antes de tentar inserí-lo
          Result := ConsistirCampoRelatorio(CodRelatorio, StrToIntDef(sAux, 0));
          if Result < 0 then begin
            Rollback;
            Exit;
          end;

          Q.ParamByName('cod_campo').AsInteger := StrToInt(sAux);
          Q.ParamByName('num_ordem').AsInteger := NumOrdem;
          Q.ExecSQL;
          Inc(NumOrdem);
        end;
      end;
      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(919, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -919;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntRelatorios.Pesquisar(CodRelatorio: Integer): Integer;
const
  Metodo: Integer = 309;
  NomeMetodo: String = 'Pesquisar';
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

  Query.Close;
  with Query.SQL do
  begin
    Clear;
{$IFDEF MSSQL}
    Add('select ' +
        '  tcr.cod_relatorio as CodRelatorio' +
        '  , tcr.cod_campo as CodCampo ' +
        '  , case tcr.ind_restringe_pesquisa when ''S'' then tcr.nom_campo + ''*'' else tcr.nom_campo end as NomCampo ' +
        '  , tcr.nom_field as NomField ' +
        '  , tcr.txt_titulo as TxtTitulo ' +
        '  , tcr.qtd_largura as QtdLargura ' +
        '  , tcr.ind_campo_default as IndCampoDefault ' +
        '  , tcr.ind_campo_obrigatorio as IndCampoObrigatorio ' +
        '  , tcr.num_ordem_default as NumOrdemDefault ' +
        '  , isnull(tcru.num_ordem, tcr.num_ordem_default) as NumOrdem ' +
        '  , case isnull(tcru.cod_relatorio, -1) ' +
        '      when -1 then ''N'' ' +
        '      else ''S'' ' +
        '    end as IndSelecaoUsuario ' +
        'from ' +
        '  tab_campo_relatorio_usuario tcru ' +
        '  , tab_campo_relatorio tcr ' +
        'where ' +
        '  tcru.cod_usuario = :cod_usuario ' +
        '  and tcru.cod_relatorio =* tcr.cod_relatorio ' +
        '  and tcru.cod_campo =* tcr.cod_campo ' +
        '  and tcr.cod_relatorio = :cod_relatorio ' +
        'order by ' +
        '  NumOrdem ');
{$ENDIF}
  end;
  Try
    Query.ParamByName('cod_relatorio').AsInteger := CodRelatorio;
    Query.ParamByName('cod_usuario').AsInteger := Conexao.CodUsuario;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(922, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -922;
      Exit;
    End;
  End;
end;

function TIntRelatorios.CampoAssociado(CodCampo: Integer): Integer;
const
  NomeMetodo: String = 'CampoAssociado';
begin
  Try
     if Query.Active and Query.Locate('CodCampo;IndSelecaoUsuario',
      VarArrayOf([CodCampo, 'S']), []) then begin
      Result := 1;
    end else begin
      Result := 0;
    end;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1003, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1003;
      Exit;
    End;
  End;
end;

end.
