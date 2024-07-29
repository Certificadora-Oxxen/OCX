// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 06/01/2003
// *  Documentação       : Atributo de animais
// *  Código Classe      :
// *  Descrição Resumida : Cadastro de Agrupamento de raças
// ************************************************************************************************
// *  Últimas Alterações
// ************************************************************************************************

unit UIntAgrupamentosRacas;

{$DEFINE MSSQL}

interface

uses uIntClassesBasicas, uIntAgrupamentoRacas, dbtables, sysutils, db;

type
  { TIntAgrupamentosRacas }
  TIntAgrupamentosRacas = class(TIntClasseBDNavegacaoBasica)
  private
    FIntAgrupamentoRacas : TIntAgrupamentoRacas;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Buscar(CodAgrupamentoRacas: Integer): Integer;
    function Inserir(CodTipoAgrupamentoRacas: Integer;
      SglAgrupamentoRacas, DesAgrupamentoRacas: String): Integer;
    function Alterar(CodAgrupamentoRacas: Integer;
      SglAgrupamentoRacas, DesAgrupamentoRacas: String): Integer;
    function Excluir(CodAgrupamentoRacas: Integer): Integer;
    function AdicionarRaca(CodAgrupamentoRacas,
      CodRaca: Integer; QtdFracaoRaca: Double): Integer;
    function RetirarRaca(CodAgrupamentoRaca,CodRaca: Integer): Integer;
    function PesquisarRacas(CodAgrupamentoRacas: Integer;
      IndRacasNoAgrupamento, CodOrdenacao: String): Integer;
    function Pesquisar(CodTipoAgrupamento: Integer;
      IndDetalharRacas, CodOrdenacao: String): Integer;

    property IntAgrupamentoRacas : TIntAgrupamentoRacas read FIntAgrupamentoRacas write FIntAgrupamentoRacas;
  end;

implementation

{ TIntLote }
constructor TIntAgrupamentosRacas.Create;
begin
  inherited;
  FIntAgrupamentoRacas := TIntAgrupamentoRacas.Create;
end;

destructor TIntAgrupamentosRacas.Destroy;
begin
  FIntAgrupamentoRacas.Free;
  inherited;
end;

function TIntAgrupamentosRacas.Buscar(CodAgrupamentoRacas: Integer): Integer;
const
  NomMetodo: String = 'Buscar';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(396) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Tenta Buscar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select cod_agrupamento_racas as CodAgrupamentoRacas, ');
      Q.SQL.Add('       sgl_agrupamento_racas as SglAgrupamentoRacas, ');
      Q.SQL.Add('       des_agrupamento_racas as DesAgrupamentoRacas ');
      Q.SQL.Add(' from tab_agrupamento_racas ');
      Q.SQL.Add(' where cod_agrupamento_racas = :CodAgrupamentoRacas ');
{$ENDIF}
      Q.ParamByName('CodAgrupamentoRacas').AsInteger         := CodAgrupamentoRacas;
      Q.Open;

      // Verifica se existe registro para busca
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1255, Self.ClassName, NomMetodo, []);
        Result := -1255;
        Exit;
      End;

      // Obtem informações do registro
      IntAgrupamentoRacas.CodAgrupamentoRacas   := Q.FieldByName('CodAgrupamentoRacas').AsInteger;
      IntAgrupamentoRacas.SglAgrupamentoRacas   := Q.FieldByName('SglAgrupamentoRacas').AsString;
      IntAgrupamentoRacas.DesAgrupamentoRacas   := Q.FieldByName('DesAgrupamentoRacas').AsString;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1256, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1256;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAgrupamentosRacas.Inserir(CodTipoAgrupamentoRacas: Integer;
  SglAgrupamentoRacas, DesAgrupamentoRacas: String): Integer;
const
  NomMetodo: String = 'Inserir';
var
  Q : THerdomQuery;
  CodAgrupamentoRacas : Integer;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(397) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  // Trata sigla do agrupamento de raça
  Result := VerificaString(SglAgrupamentoRacas, 'Sigla do agrupamento de raça');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglAgrupamentoRacas, 3, 'Sigla do agrupamento de raça');
  If Result < 0 Then Begin
    Exit;
  End;

  // Trata descrição do agrupamento de raça
  Result := VerificaString(DesAgrupamentoRacas, 'Descrição do agrupamento de raça');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesAgrupamentoRacas, 35, 'Descrição do agrupamento de raça');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_agrupamento_racas tar, tab_tipo_agrup_racas tta ');
      Q.SQL.Add(' where tar.sgl_agrupamento_racas = :sgl_agrupamento_racas ');
      Q.SQL.Add(' and   tar.cod_tipo_agrup_racas = tta.cod_tipo_agrup_racas ');
      Q.SQL.Add(' and   tta.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('sgl_agrupamento_racas').AsString := SglAgrupamentoRacas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1257, Self.ClassName, NomMetodo, [SglAgrupamentoRacas]);
        Result := -1257;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade da descrição
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_agrupamento_racas tar, tab_tipo_agrup_racas tta ');
      Q.SQL.Add(' where tar.des_agrupamento_racas = :des_agrupamento_racas ');
      Q.SQL.Add(' and   tar.cod_tipo_agrup_racas = tta.cod_tipo_agrup_racas ');
      Q.SQL.Add(' and   tta.dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('des_agrupamento_racas').AsString := DesAgrupamentoRacas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1258, Self.ClassName, NomMetodo, [DesAgrupamentoRacas]);
        Result := -1258;
        Exit;
      End;
      Q.Close;

      // Verifica se o tipo de agrupamento é válido
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_tipo_agrup_racas ');
      Q.SQL.Add(' where cod_tipo_agrup_racas = :cod_tipo_agrup_racas ');
      Q.SQL.Add(' and   dta_fim_validade is null ');
{$ENDIF}
      Q.ParamByName('cod_tipo_agrup_racas').AsInteger := CodTipoAgrupamentoRacas;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1259, Self.ClassName, NomMetodo, []);
        Result := -1259;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Pega próximo código
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(max(cod_agrupamento_racas), 0) + 1 as cod_agrupamento_racas ');
      Q.SQL.Add('  from tab_agrupamento_racas ');
{$ENDIF}
      Q.Open;
      CodAgrupamentoRacas := Q.FieldByName('cod_agrupamento_racas').AsInteger;

      // Tenta Inserir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('insert into tab_agrupamento_racas ');
      Q.SQL.Add(' (cod_agrupamento_racas, ');
      Q.SQL.Add('  sgl_agrupamento_racas, ');
      Q.SQL.Add('  des_agrupamento_racas, ');
      Q.SQL.Add('  cod_tipo_agrup_racas) ');
      Q.SQL.Add('values ');
      Q.SQL.Add(' (:cod_agrupamento_racas, ');
      Q.SQL.Add('  :sgl_agrupamento_racas, ');
      Q.SQL.Add('  :des_agrupamento_racas, ');
      Q.SQL.Add('  :cod_tipo_agrupamento_racas) ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.ParamByName('sgl_agrupamento_racas').AsString := SglAgrupamentoRacas;
      Q.ParamByName('des_agrupamento_racas').AsString := DesAgrupamentoRacas;
      Q.ParamByName('cod_tipo_agrupamento_racas').AsInteger := CodTipoAgrupamentoRacas;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := CodAgrupamentoRacas;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1260, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1260;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAgrupamentosRacas.Alterar(CodAgrupamentoRacas: Integer;
  SglAgrupamentoRacas, DesAgrupamentoRacas: String): Integer;
const
  NomMetodo: String = 'Alterar';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(398) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  //-----------------------------------
  // Trata sigla do agrupamento de raça
  //-----------------------------------
  Result := VerificaString(SglAgrupamentoRacas, 'Sigla do agrupamento da raça');
  If Result < 0 Then Begin
    Exit;
  End;

  Result := TrataString(SglAgrupamentoRacas, 3, 'Sigla do agrupamento da raça');
  If Result < 0 Then Begin
    Exit;
  End;
  //---------------------------------------
  // Trata descrição do agrupamento de raça
  //---------------------------------------
  Result := VerificaString(DesAgrupamentoRacas, 'Descrição do agrupamento da raça');
  If Result < 0 Then Begin
    Exit;
  End;
  Result := TrataString(DesAgrupamentoRacas, 35, 'Descrição do agrupamento da raça');
  If Result < 0 Then Begin
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica existência do registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_agrupamento_racas ');
      Q.SQL.Add(' where cod_agrupamento_racas = :cod_agrupamento_racas ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1255, Self.ClassName, 'Alterar', []);
        Result := -1255;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de sigla
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_agrupamento_racas tar, tab_tipo_agrup_racas tta ');
      Q.SQL.Add(' where tar.sgl_agrupamento_racas = :sgl_agrupamento_racas ');
      Q.SQL.Add(' and   tar.cod_tipo_agrup_racas = tta.cod_tipo_agrup_racas ');
      Q.SQL.Add(' and   tta.dta_fim_validade is null ');
      Q.SQL.Add(' and   tar.cod_agrupamento_racas != :cod_agrupamento_racas ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.ParamByName('sgl_agrupamento_racas').AsString := SglAgrupamentoRacas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1257, Self.ClassName, NomMetodo, [SglAgrupamentoRacas]);
        Result := -1257;
        Exit;
      End;
      Q.Close;

      // Verifica duplicidade de descrição
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_agrupamento_racas tar, tab_tipo_agrup_racas tta ');
      Q.SQL.Add(' where tar.des_agrupamento_racas = :des_agrupamento_racas ');
      Q.SQL.Add(' and   tar.cod_tipo_agrup_racas = tta.cod_tipo_agrup_racas ');
      Q.SQL.Add(' and   tta.dta_fim_validade is null ');
      Q.SQL.Add(' and   tar.cod_agrupamento_racas != :cod_agrupamento_racas ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.ParamByName('des_agrupamento_racas').AsString := DesAgrupamentoRacas;
      Q.Open;
      If not Q.IsEmpty Then Begin
        Mensagens.Adicionar(1258, Self.ClassName, NomMetodo, [DesAgrupamentoRacas]);
        Result := -1258;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Alterar Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('update tab_agrupamento_racas ');
      Q.SQL.Add('   set sgl_agrupamento_racas = :sgl_agrupamento_racas ');
      Q.SQL.Add('     , des_agrupamento_racas = :des_agrupamento_racas ');
      Q.SQL.Add(' where cod_agrupamento_racas = :cod_agrupamento_racas ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.ParamByName('sgl_agrupamento_racas').AsString := SglAgrupamentoRacas;
      Q.ParamByName('des_agrupamento_racas').AsString := DesAgrupamentoRacas;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1261, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1261;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAgrupamentosRacas.Excluir(CodAgrupamentoRacas: Integer): Integer;
const
  NomMetodo: String = 'Excluir';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(399) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, 'Excluir', []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
       //-------------------------------
      // Verifica existência do registro
      //--------------------------------
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_agrupamento_racas ');
      Q.SQL.Add(' where cod_agrupamento_racas = :cod_agrupamento_racas ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.Open;
      If Q.IsEmpty Then Begin
        Mensagens.Adicionar(1255, Self.ClassName, NomMetodo, []);
        Result := -1255;
        Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Excluir as raças associadas
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_composicao_agrup_racas ');
      Q.SQL.Add(' where cod_agrupamento_racas = :cod_agrupamento_racas ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.ExecSQL;

      // Tenta Excluir Registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_agrupamento_racas ');
      Q.SQL.Add(' where cod_agrupamento_racas = :cod_agrupamento_racas ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna status "ok" do método
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1262, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1262;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAgrupamentosRacas.AdicionarRaca(CodAgrupamentoRacas,
  CodRaca: Integer; QtdFracaoRaca: Double): Integer;
const
  NomMetodo: String = 'AdicionarRaca';
var
  Q : THerdomQuery;
  tipo : integer; // 1- inserção 2 - update
begin
  Result := -1;
  tipo := 1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(400) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  // Verifica se a fração da raça é superior a zero e menor ou igual a um
  If (QtdFracaoRaca <= 0) or (QtdFracaoRaca > 1) Then Begin
    Mensagens.Adicionar(1375, Self.ClassName, NomMetodo, []);
    Result := -1375;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se a raça já está no agrupamento
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_composicao_agrup_racas ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add(' and   cod_agrupamento_racas = :cod_agrupamento_racas ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If not Q.IsEmpty then begin
         tipo := 2;
      End;
      Q.Close;

      // Verifica se a fração da raça (no mesmo agrupamento ou tipo de agrupamento) é inferior a 1
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select isnull(sum(qtd_fracao_raca),0) as total_fracao from tab_agrupamento_racas t1, tab_composicao_agrup_racas t2 ');
      Q.SQL.Add(' where t1.cod_agrupamento_racas = t2.cod_agrupamento_racas ');
      Q.SQL.Add(' and   t2.cod_raca = :cod_raca ');
      Q.SQL.Add(' and   t1.cod_tipo_agrup_racas = (select cod_tipo_agrup_racas from tab_agrupamento_racas where cod_agrupamento_racas = :cod_agrupamento_racas) ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If Q.fieldbyname('total_fracao').asfloat + QtdFracaoRaca > 1 Then Begin
         Mensagens.Adicionar(1376, Self.ClassName, NomMetodo, []);
         Result := -1376;
         Exit;
      End;
      Q.Close;

      // Verifica se a raça é pura
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_raca ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add(' and   ind_raca_pura = ''S'' ');
{$ENDIF}
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
         Mensagens.Adicionar(1265, Self.ClassName, NomMetodo, []);
         Result := -1265;
         Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Inserir o registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      if tipo = 1 then begin
         Q.SQL.Add('insert into tab_composicao_agrup_racas ');
         Q.SQL.Add(' (cod_agrupamento_racas, ');
         Q.SQL.Add('  cod_raca, ');
         Q.SQL.Add('  qtd_fracao_raca) ');
         Q.SQL.Add('values ');
         Q.SQL.Add(' (:cod_agrupamento_racas, ');
         Q.SQL.Add('  :cod_raca, ');
         Q.SQL.Add('  :qtd_fracao_raca) ');
      end else begin
         Q.SQL.Add('update tab_composicao_agrup_racas ');
         Q.SQL.Add(' set ');
         Q.SQL.Add(' qtd_fracao_raca = :qtd_fracao_raca ');
         Q.SQL.Add(' where ');
         Q.SQL.Add(' cod_agrupamento_racas =:cod_agrupamento_racas and ');
         Q.SQL.Add(' cod_raca = :cod_raca ');
     end;
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRacas;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.ParamByName('qtd_fracao_raca').AsFloat := QtdFracaoRaca;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1266, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1266;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAgrupamentosRacas.RetirarRaca(CodAgrupamentoRaca,
  CodRaca: Integer): Integer;
const
  NomMetodo: String = 'RetirarRaca';
var
  Q : THerdomQuery;
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(401) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Q := THerdomQuery.Create(Conexao, nil);
  Try
    Try
      // Verifica se a raça não está no agrupamento
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('select 1 from tab_composicao_agrup_racas ');
      Q.SQL.Add(' where cod_raca = :cod_raca ');
      Q.SQL.Add(' and   cod_agrupamento_racas = :cod_agrupamento_racas ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRaca;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.Open;
      If Q.IsEmpty Then Begin
         Exit;
      End;
      Q.Close;

      // Abre transação
      BeginTran;

      // Tenta Excluir o registro
      Q.SQL.Clear;
{$IFDEF MSSQL}
      Q.SQL.Add('delete from tab_composicao_agrup_racas ');
      Q.SQL.Add(' where ');
      Q.SQL.Add(' cod_raca = :cod_raca ');
      Q.SQL.Add(' and cod_agrupamento_racas = :cod_agrupamento_racas ');
{$ENDIF}
      Q.ParamByName('cod_agrupamento_racas').AsInteger := CodAgrupamentoRaca;
      Q.ParamByName('cod_raca').AsInteger := CodRaca;
      Q.ExecSQL;

      // Cofirma transação
      Commit;

      // Retorna código do registro inserido
      Result := 0;
    Except
      On E: Exception do Begin
        Rollback;
        Mensagens.Adicionar(1268, Self.ClassName, NomMetodo, [E.Message]);
        Result := -1268;
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

function TIntAgrupamentosRacas.PesquisarRacas(CodAgrupamentoRacas: Integer;
  IndRacasNoAgrupamento, CodOrdenacao: String): Integer;
const
  NomMetodo: String = 'PesquisarRacas';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(402) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;
{$IFDEF MSSQL}
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select tr.cod_raca as CodRaca ');
  Query.SQL.Add('     , tr.sgl_raca as SglRaca ');
  Query.SQL.Add('     , tr.des_raca as DesRaca ');
  Query.SQL.Add('     , tc.qtd_fracao_raca as QtdFracaoRaca ');
  Query.SQL.Add('     , case tc.cod_agrupamento_racas  ');
  Query.SQL.Add('       when null then ''N'' ');
  Query.SQL.Add('       else ''S'' ');
  Query.SQL.Add('       end as IndRacasNoAgrupamento ');
  Query.SQL.Add('from tab_raca tr ');
  Query.SQL.Add('   , tab_composicao_agrup_racas tc ');
  if IndRacasNoAgrupamento = 'S'
     then begin
       Query.SQL.Add(' where tr.cod_raca = tc.cod_raca ');
     end else if IndRacasNoAgrupamento = 'N'
                then begin
                  Query.SQL.Add(' where tr.cod_raca *= tc.cod_raca ');
                  Query.SQL.Add(' and tr.cod_raca not in (select cod_raca ');
                  Query.SQL.Add(' from tab_composicao_agrup_racas ');
                  Query.SQL.Add(' where cod_agrupamento_racas in ');
                  Query.SQL.Add(' (select cod_agrupamento_racas from tab_agrupamento_racas where cod_tipo_agrup_racas in ');
                  Query.SQL.Add(' (select cod_tipo_agrup_racas from tab_agrupamento_racas where cod_agrupamento_racas = :cod_agrupamento_racas)))');
                end
                else Query.SQL.Add(' where tr.cod_raca *= tc.cod_raca ');
  Query.SQL.Add(' and tc.cod_agrupamento_racas=:cod_agrupamento_racas ');
  Query.SQL.Add(' and tr.ind_raca_pura = ''S'' ');
  if CodOrdenacao = 'S' then
    Query.SQL.Add(' order by tr.sgl_raca ')
  else if CodOrdenacao = 'D' then
    Query.SQL.Add(' order by tr.des_raca ');
  {$ENDIF}
  Try
  Query.Parambyname('cod_agrupamento_racas').asinteger := CodAgrupamentoRacas;
  Query.Open;
  Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1269, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1269;
      Exit;
    End;
  End;
end;

function TIntAgrupamentosRacas.Pesquisar(CodTipoAgrupamento: Integer;
  IndDetalharRacas, CodOrdenacao: String): Integer;
const
  NomMetodo: String = 'Pesquisar';
begin
  Result := -1;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomMetodo);
    Exit;
  End;

  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(403) Then Begin
    Mensagens.Adicionar(188, Self.ClassName, NomMetodo, []);
    Result := -188;
    Exit;
  End;

  Query.Close;
{$IFDEF MSSQL}
  Query.SQL.Clear;
  if IndDetalharRacas = 'N' then begin
     Query.SQL.Add('select cod_agrupamento_racas as CodAgrupamentoRacas ');
     Query.SQL.Add('     , sgl_agrupamento_racas as SglAgrupamentoRacas ');
     Query.SQL.Add('     , des_agrupamento_racas as DesAgrupamentoRacas ');
     Query.SQL.Add(' from tab_agrupamento_racas as ta  ');
     Query.SQL.Add(' where cod_tipo_agrup_racas = :cod_tipo_agrupamento_racas ');
     if CodOrdenacao = 'S' then
        Query.SQL.Add(' order by sgl_agrupamento_racas ')
     else if CodOrdenacao = 'D' then
        Query.SQL.Add(' order by des_agrupamento_racas ');
  end else begin
     Query.SQL.Add('select ta.cod_agrupamento_racas as CodAgrupamentoRacas ');
     Query.SQL.Add('     , ta.sgl_agrupamento_racas as SglAgrupamentoRacas ');
     Query.SQL.Add('     , ta.des_agrupamento_racas as DesAgrupamentoRacas ');
     Query.SQL.Add('     , tr.sgl_raca as SglRaca ');
     Query.SQL.Add('     , tr.des_raca as DesRaca ');
     Query.SQL.Add(' from tab_agrupamento_racas as ta ');
     Query.SQL.Add('     ,tab_raca as tr ');
     Query.SQL.Add('     ,tab_composicao_agrup_racas as tc ');
     Query.SQL.Add(' where ta.cod_tipo_agrup_racas = :cod_tipo_agrupamento_racas ');
     Query.SQL.Add(' and   ta.cod_agrupamento_racas = tc.cod_agrupamento_racas ');
     Query.SQL.Add(' and   tc.cod_raca = tr.cod_raca ');
     if CodOrdenacao = 'S' then
        Query.SQL.Add(' order by ta.sgl_agrupamento_racas, tr.sgl_raca ')
     else if CodOrdenacao = 'D' then
        Query.SQL.Add(' order by ta.des_agrupamento_racas, tr.des_raca ');
  end;
{$ENDIF}

  Try
    Query.Parambyname('cod_tipo_agrupamento_racas').asinteger := CodTipoAgrupamento;
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(1270, Self.ClassName, NomMetodo, [E.Message]);
      Result := -1270;
      Exit;
    End;
  End;
end;
end.
