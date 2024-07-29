// ********************************************************************
// *  Projeto : BoiTata
// *  Sistema : Controle de Acesso
// *  Desenvolvedor : Hitalo Cordeiro Silva
// *  Versão  : 1
// *  Data : 16/07/2002
// *  Descrição Resumida : Cadastro de Anuniciantes
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

unit uIntAnunciantes;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntAnunciante, dbtables, sysutils, db;

type
  { TIntAnunciantes }
  TIntAnunciantes = class(TIntClasseBDNavegacaoBasica)
  private
    FIntAnunciante : TIntAnunciante;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Pesquisar(IndPesquisarDesativados: Boolean): Integer;
    function Inserir(NomAnunciante, TxtEmailAnunciante: String): Integer;
    function Alterar(CodAnunciante: Integer; TxtEmailAnunciante: String): Integer;
    function Excluir(CodAnunciante: Integer): Integer;
    function Buscar(CodAnunciante: Integer): Integer;
    property IntAnunciante : TIntAnunciante read FIntAnunciante write FIntAnunciante;
  end;

implementation

{ TIntAnunciantes }
constructor TIntAnunciantes.Create;
begin
  inherited;
  FIntAnunciante := TIntAnunciante.Create;
end;

destructor TIntAnunciantes.Destroy;
begin
  FIntAnunciante.Free;
  inherited;
end;

function TIntAnunciantes.Pesquisar(IndPesquisarDesativados: Boolean): Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Pesquisar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(23) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Pesquisar', []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  Query.SQL.Add('select cod_anunciante as CodAnunciante, ');
  Query.SQL.Add('       nom_anunciante as NomAnunciante, ');
  Query.SQL.Add('       txt_email_anunciante as TxtEmailAnunciante, ');
  Query.SQL.Add('       dta_fim_validade as DtaFimValidade ');
  Query.SQL.Add('  from tab_anunciante ');
  Query.SQL.Add(' where ((dta_fim_validade is null) or (:ind_pesquisar_desativados = 1))' );
  Query.SQL.Add(' order by nom_anunciante' );
{$ENDIF}
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
      Mensagens.Adicionar(136, Self.ClassName, 'Pesquisar', [E.Message]);
      Result := -136;
      Exit;
    End;
  End;
end;

function TIntAnunciantes.Inserir(NomAnunciante, TxtEmailAnunciante: String): Integer;
var
  Q : THerdomQuery;
  CodAnunciante : Integer;
begin
  Result := -1;

  If Not Inicializado Then Begin
    RaiseNaoInicializado('Inserir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(24) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Inserir', []);
    Result := -188;
    Exit;
  End;

  If trim(NomAnunciante) = '' Then Begin
    Mensagens.Adicionar(238, Self.ClassName, 'Inserir', []);
    Result := -238;
    Exit;
  End;

  result := TrataString(NomAnunciante,30,'Nome do Anunciante');

  if result < 0 then
    exit;

  If trim(TxtEmailAnunciante) <> '' Then Begin
    result := TrataString(TxtEmailAnunciante,60,'E-mail do Anunciante');

    if result < 0 then
      exit;
  End;

  //----------------------------------------------------
  //Verifica se a variável não contem espaços em brancos
  //----------------------------------------------------
  if Pos(' ', TxtEmailAnunciante) > 0 then begin
    Mensagens.Adicionar(294, Self.ClassName, 'Inserir', []);
    result := -294;
    exit;
  end;

  Q := THerdomQuery.Create(Conexao, nil);

  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_anunciante ');
      Q.SQL.Add(' where nom_anunciante = :nom_anunciante ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('nom_anunciante').AsString := NomAnunciante;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(142, Self.ClassName, 'Inserir', [NomAnunciante]);
        Result := -142;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_anunciante), 0) + 1 as cod_anunciante from tab_anunciante');
{$ENDIF}
      Q.Open;
      CodAnunciante := Q.FieldByName('cod_anunciante').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_anunciante ');
      Q.SQL.Add(' (cod_anunciante, ');
      Q.SQL.Add('  nom_anunciante, ');
      Q.SQL.Add('  txt_email_anunciante, ');
      Q.SQL.Add('  dta_fim_validade) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_anunciante, ');
      Q.SQL.Add('  :nom_anunciante, ');
      Q.SQL.Add('  :txt_email_anunciante, ');
      Q.SQL.Add('  null) ');
{$ENDIF}
      Q.ParamByName('cod_anunciante').AsInteger        := CodAnunciante;
      Q.ParamByName('nom_anunciante').AsString         := NomAnunciante;
      If TxtEmailAnunciante = '' Then Begin
        Q.ParamByName('txt_email_anunciante').DataType := ftString;
        Q.ParamByName('txt_email_anunciante').Clear;
      End Else Begin
        Q.ParamByName('txt_email_anunciante').AsString := TxtEmailAnunciante;
      End;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do anunciante criado
      Result := CodAnunciante;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(137, Self.ClassName, 'Inserir', [E.Message]);
        Result := -137;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAnunciantes.Alterar(CodAnunciante: Integer;
  TxtEmailAnunciante: String): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Alterar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(25) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Alterar', []);
    Result := -188;
    Exit;
  End;

  If trim(TxtEmailAnunciante) <> '' Then Begin
    result := TrataString(TxtEmailAnunciante,60,'E-mail do Anunciante');

    if result < 0 then
      exit;
  End;


  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_anunciante ');
      Q.SQL.Add(' where  cod_anunciante = :cod_anunciante ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_anunciante').AsInteger := CodAnunciante;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(141, Self.ClassName, 'Alterar', [IntToStr(CodAnunciante)]);
        Result := -141;
        Exit;
      End;
      Q.Close;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_anunciante ');
      Q.SQL.Add('   set txt_email_anunciante = :txt_email_anunciante ');
      Q.SQL.Add(' where cod_anunciante = :cod_anunciante ');
{$ENDIF}
      Q.ParamByName('cod_anunciante').AsInteger      := CodAnunciante;
      If TxtEmailAnunciante = '' Then Begin
        Q.ParamByName('txt_email_anunciante').DataType := ftString;
        Q.ParamByName('txt_email_anunciante').Clear;
      End Else Begin
        Q.ParamByName('txt_email_anunciante').AsString := TxtEmailAnunciante;
      End;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(138, Self.ClassName, 'Alterar', [E.Message]);
        Result := -138;
        Exit;
      End;
    End;
  Finally
      Q.Free;
  End;
end;

function TIntAnunciantes.Excluir(CodAnunciante: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Excluir');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(27) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existencia do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_anunciante ');
      Q.SQL.Add(' where cod_anunciante = :cod_anunciante ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_anunciante').AsInteger := CodAnunciante;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(141, Self.ClassName, 'Excluir', [IntToStr(CodAnunciante)]);
        Result := -141;
        Exit;
      End;
      Q.Close;

      // Consiste se há banner ativo para esse anunciante
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_banner ');
      Q.SQL.Add(' where cod_anunciante = :cod_anunciante ');
      Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_anunciante').AsInteger := CodAnunciante;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(143, Self.ClassName, 'Excluir', [IntToStr(CodAnunciante)]);
        Result := -143;
        Exit;
      End;
      Q.Close;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_anunciante ');
      Q.SQL.Add('   set dta_fim_validade = getdate() ');
      Q.SQL.Add(' where cod_anunciante = :cod_anunciante ');
{$ENDIF}
      Q.ParamByName('cod_anunciante').AsInteger      := CodAnunciante;
      Q.ExecSQL;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(139, Self.ClassName, 'Excluir', [E.Message]);
        Result := -139;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAnunciantes.Buscar(CodAnunciante: Integer): Integer;
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado('Buscar');
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(26) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Buscar', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_anunciante, ');
      Q.SQL.Add('       nom_anunciante, ');
      Q.SQL.Add('       txt_email_anunciante, ');
      Q.SQL.Add('       dta_fim_validade ');
      Q.SQL.Add('  from tab_anunciante ');
      Q.SQL.Add(' where cod_anunciante = :cod_anunciante ');
//hitalo  Q.SQL.Add('   and dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_anunciante').AsInteger := CodAnunciante;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(141, Self.ClassName, 'Buscar', [IntToStr(CodAnunciante)]);
        Result := -141;
        Exit;
      End;

      // Obtem informações do registro
      IntAnunciante.Codigo             := Q.FieldByName('cod_anunciante').AsInteger;
      IntAnunciante.NomAnunciante      := Q.FieldByName('nom_anunciante').AsString;
      IntAnunciante.TxtEmailAnunciante := Q.FieldByName('txt_email_anunciante').AsString;
      IntAnunciante.DtaFimValidade     := Q.FieldByName('Dta_fim_validade').AsDateTime;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(140, Self.ClassName, 'Buscar', [E.Message]);
        Result := -140;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;
end.
